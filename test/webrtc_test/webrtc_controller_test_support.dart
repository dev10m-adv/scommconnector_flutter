import 'dart:async';

import 'package:scommconnector/core/errors/errors.dart';
import 'package:scommconnector/core/resilience/online_aware_resilience.dart';
import 'package:scommconnector/features/webrtc/application/controllers/webrtc_controller.dart';
import 'package:scommconnector/features/webrtc/application/state/webrtc_state.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_connection_state.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_data_message.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_candidate.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_route.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_session_description.dart';
import 'package:scommconnector/features/webrtc/domain/repositories/webrtc_repository.dart';
import 'package:scommconnector/features/webrtc/domain/services/connection_recovery_strategy.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/add_data_channel_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/add_remote_ice_candidate_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/close_webrtc_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/connection_state_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/create_webrtc_answer_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/create_webrtc_offer_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/initialize_webrtc_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/remove_data_channel_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/restart_ice_and_create_offer_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/send_webrtc_data_usecase.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/set_remote_answer_usecase.dart';
import 'package:test/test.dart';

Future<void> runTemporaryDisconnectAutoRecoverScenario() async {
  final harness = _ControllerHarness();
  await harness.run((controller, repository, recovery, _) async {
    await controller.initialize(dataChannels: const ['main-channel']);
    repository.emitConnectionState(WebRtcConnectionState.connected);
    await _waitForCondition(
      () =>
          harness.states.any((state) => state.status == WebRtcStatus.connected),
      description: 'controller to become connected',
    );

    repository.emitConnectionState(WebRtcConnectionState.disconnected);
    await _waitForCondition(
      () => recovery.recoverCalls == 1,
      description: 'one recovery attempt to start',
    );

    repository.emitConnectionState(WebRtcConnectionState.connected);
    await _waitForCondition(
      () => harness.states.last.status == WebRtcStatus.connected,
      description: 'controller to recover back to connected',
    );

    expect(
      harness.states.where((state) => state.status == WebRtcStatus.failed),
      isEmpty,
    );
  });
}

Future<void> runDisconnectLongerThanGraceWindowScenario() async {
  final harness = _ControllerHarness(
    recoveryStrategy: _ControlledRecoveryStrategy(
      error: const ServerException(message: 'Recovery exhausted.'),
    ),
  );

  await harness.run((controller, repository, recovery, _) async {
    await controller.initialize(dataChannels: const ['main-channel']);
    repository.emitConnectionState(WebRtcConnectionState.disconnected);

    await _waitForCondition(
      () => recovery.recoverCalls == 1,
      description: 'one recovery attempt to run',
    );
    await _waitForCondition(
      () => harness.states.any((state) => state.status == WebRtcStatus.failed),
      description: 'controller to move to failed state',
    );

    expect(harness.states.last.status, WebRtcStatus.failed);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(recovery.recoverCalls, 1);
  });
}

Future<void> runReconnectOncePerRecoveryCycleScenario() async {
  final recovery = _ControlledRecoveryStrategy.pending();
  final harness = _ControllerHarness(recoveryStrategy: recovery);

  await harness.run((controller, repository, recovery, _) async {
    await controller.initialize(dataChannels: const ['main-channel']);
    repository.emitConnectionState(WebRtcConnectionState.disconnected);
    repository.emitConnectionState(WebRtcConnectionState.failed);
    repository.emitConnectionState(WebRtcConnectionState.disconnected);

    await _waitForCondition(
      () => recovery.recoverCalls == 1,
      description: 'one recovery cycle to start',
    );

    recovery.complete();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(recovery.recoverCalls, 1);
  });
}

Future<void> runNoNestedListenersLeakScenario() async {
  final harness = _ControllerHarness();
  await harness.run((controller, repository, recovery, _) async {
    for (var index = 0; index < 3; index++) {
      await controller.initialize(dataChannels: const ['main-channel']);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await controller.close();
    }

    expect(repository.maxConnectionStateListeners, 1);
    expect(repository.activeConnectionStateListeners, 0);
    expect(recovery.recoverCalls, 0);
  });
}

Future<void> runInitializeConnectCloseScenario() async {
  final harness = _ControllerHarness();
  await harness.run((controller, repository, recovery, onlineAwareness) async {
    await controller.initialize(dataChannels: const ['main-channel']);
    repository.emitConnectionState(WebRtcConnectionState.connected);

    await _waitForCondition(
      () =>
          harness.states.any((state) => state.status == WebRtcStatus.connected),
      description: 'connected state',
    );

    await controller.close();
    repository.emitConnectionState(WebRtcConnectionState.disconnected);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(harness.states.last.status, WebRtcStatus.closed);
    expect(recovery.recoverCalls, 0);
    expect(repository.closeCalls, 1);
    expect(onlineAwareness.stopCalls, 1);
  });
}

Future<void> runIgnoreInternetRecoveryDuringManualCloseScenario() async {
  final onlineAwareness = _FakeOnlineAwareResilience(
    invokeRecoveryDuringStop: true,
  );
  final harness = _ControllerHarness(onlineAwareness: onlineAwareness);

  await harness.run((controller, repository, recovery, _) async {
    await controller.initialize(dataChannels: const ['main-channel']);
    await controller.close();

    await _waitForCondition(
      () =>
          harness.states.isNotEmpty &&
          harness.states.last.status == WebRtcStatus.closed,
      description: 'controller to publish the closed state',
    );

    expect(recovery.recoverCalls, 0);
    expect(harness.states.last.status, WebRtcStatus.closed);
  });
}

Future<void> runSingleRecoveryFlowScenario() async {
  final recovery = _ControlledRecoveryStrategy.pending();
  final harness = _ControllerHarness(recoveryStrategy: recovery);

  await harness.run((controller, repository, recovery, onlineAwareness) async {
    await controller.initialize(dataChannels: const ['main-channel']);

    repository.emitConnectionState(WebRtcConnectionState.disconnected);

    await _waitForCondition(
      () => recovery.recoverCalls == 1,
      description: 'single recovery flow to start',
    );

    repository.emitConnectionState(WebRtcConnectionState.failed);
    unawaited(onlineAwareness.triggerRecoveryCallback());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(recovery.recoverCalls, 1);

    recovery.complete();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(recovery.recoverCalls, 1);
  });
}

Future<void> runMaxRecoveryAttemptsExhaustedScenario() async {
  final repository = _FakeWebRtcRepository()
    ..restartIceError = const ServerException(message: 'still offline');
  final strategy = ConnectionRecoveryStrategy(
    restartIceAndCreateOfferUseCase: RestartIceAndCreateOfferUseCase(
      repository,
    ),
    closeWebRtcUseCase: CloseWebRtcUseCase(repository),
  );

  await expectLater(
    strategy.recover(),
    throwsA(
      isA<ServerException>().having(
        (error) => error.message,
        'message',
        'WebRTC recovery failed after multiple attempts.',
      ),
    ),
  );
  expect(repository.restartIceCalls, 3);
  expect(repository.closeCalls, 1);
  expect(strategy.isRecovering, isFalse);
}

class _ControllerHarness {
  _ControllerHarness({
    _FakeWebRtcRepository? repository,
    _ControlledRecoveryStrategy? recoveryStrategy,
    _FakeOnlineAwareResilience? onlineAwareness,
  }) : repository = repository ?? _FakeWebRtcRepository(),
       recoveryStrategy = recoveryStrategy ?? _ControlledRecoveryStrategy(),
       onlineAwareness = onlineAwareness ?? _FakeOnlineAwareResilience() {
    controller = WebRtcController(
      repository: this.repository,
      initializeWebRtcUseCase: InitializeWebRtcUseCase(this.repository),
      createWebRtcOfferUseCase: CreateWebRtcOfferUseCase(this.repository),
      createWebRtcAnswerUseCase: CreateWebRtcAnswerUseCase(this.repository),
      setRemoteAnswerUseCase: SetRemoteAnswerUseCase(this.repository),
      addRemoteIceCandidateUseCase: AddRemoteIceCandidateUseCase(
        this.repository,
      ),
      addDataChannelUseCase: AddDataChannelUseCase(this.repository),
      removeDataChannelUseCase: RemoveDataChannelUseCase(this.repository),
      sendWebRtcDataUseCase: SendWebRtcDataUseCase(this.repository),
      closeWebRtcUseCase: CloseWebRtcUseCase(this.repository),
      recoveryStrategy: this.recoveryStrategy,
      onlineAwareness: this.onlineAwareness,
      connectionStateUseCase: ConnectionStateUseCase(this.repository),
    );
  }

  final _FakeWebRtcRepository repository;
  final _ControlledRecoveryStrategy recoveryStrategy;
  final _FakeOnlineAwareResilience onlineAwareness;
  late final WebRtcController controller;
  final states = <WebRtcState>[];

  Future<void> run(
    Future<void> Function(
      WebRtcController controller,
      _FakeWebRtcRepository repository,
      _ControlledRecoveryStrategy recovery,
      _FakeOnlineAwareResilience onlineAwareness,
    )
    body,
  ) async {
    final subscription = controller.webRtcStates.listen(states.add);
    try {
      await body(controller, repository, recoveryStrategy, onlineAwareness);
    } finally {
      await subscription.cancel();
      await controller.dispose();
      await repository.dispose();
    }
  }
}

class _FakeWebRtcRepository implements WebRtcRepository {
  final _connectionStateController =
      StreamController<WebRtcConnectionState>.broadcast();
  final _localIceController = StreamController<WebRtcIceCandidate>.broadcast();
  final _iceRouteController = StreamController<WebRtcIceRoute>.broadcast();
  final _dataMessageController =
      StreamController<WebRtcDataMessage>.broadcast();
  WebRtcIceRoute _iceRoute = const WebRtcIceRoute();

  int initializeCalls = 0;
  int closeCalls = 0;
  int restartIceCalls = 0;
  int activeConnectionStateListeners = 0;
  int maxConnectionStateListeners = 0;
  Object? restartIceError;

  @override
  Stream<WebRtcConnectionState> get connectionStates =>
      Stream.multi((controller) {
        activeConnectionStateListeners++;
        if (activeConnectionStateListeners > maxConnectionStateListeners) {
          maxConnectionStateListeners = activeConnectionStateListeners;
        }

        final subscription = _connectionStateController.stream.listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );
        controller.onCancel = () async {
          activeConnectionStateListeners--;
          await subscription.cancel();
        };
      });

  @override
  Stream<WebRtcIceCandidate> get localIceCandidates =>
      _localIceController.stream;

  @override
  Stream<WebRtcIceRoute> get iceRoutes => _iceRouteController.stream;

  @override
  Stream<WebRtcDataMessage> get dataMessages => _dataMessageController.stream;

  @override
  WebRtcIceRoute get iceRoute => _iceRoute;

  void emitConnectionState(WebRtcConnectionState state) {
    _connectionStateController.add(state);
  }

  @override
  Future<void> initialize({
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  }) async {
    initializeCalls++;
  }

  @override
  Future<WebRtcSessionDescription> createOffer({
    bool iceRestart = false,
  }) async {
    return const WebRtcSessionDescription(type: 'offer', sdp: 'offer-sdp');
  }

  @override
  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  ) async {
    return const WebRtcSessionDescription(type: 'answer', sdp: 'answer-sdp');
  }

  @override
  Future<void> setRemoteAnswer(WebRtcSessionDescription answer) async {}

  @override
  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) async {}

  @override
  Future<void> addDataChannel(String label) async {}

  @override
  Future<void> removeDataChannel(String label) async {}

  @override
  Future<void> sendData({
    required String channelLabel,
    required String message,
  }) async {}

  @override
  Future<WebRtcIceRoute> refreshIceRoute() async {
    return _iceRoute;
  }

  @override
  Future<WebRtcSessionDescription> restartIceAndCreateOffer() async {
    restartIceCalls++;
    if (restartIceError != null) {
      throw restartIceError!;
    }
    return const WebRtcSessionDescription(type: 'offer', sdp: 'recovery-offer');
  }

  @override
  Future<void> close() async {
    closeCalls++;
  }

  Future<void> dispose() async {
    await _connectionStateController.close();
    await _localIceController.close();
    await _iceRouteController.close();
    await _dataMessageController.close();
  }
}

class _ControlledRecoveryStrategy implements IConnectionRecoveryStrategy {
  _ControlledRecoveryStrategy({this.error});

  _ControlledRecoveryStrategy.pending() : error = null {
    _pending = Completer<WebRtcSessionDescription>();
  }

  final Object? error;
  Completer<WebRtcSessionDescription>? _pending;
  int recoverCalls = 0;
  bool _isRecovering = false;

  @override
  bool get isRecovering => _isRecovering;

  @override
  Future<WebRtcSessionDescription> recover() {
    recoverCalls++;
    _isRecovering = true;

    late final Future<WebRtcSessionDescription> future;
    if (_pending != null) {
      future = _pending!.future;
    } else if (error != null) {
      future = Future<WebRtcSessionDescription>.error(error!);
    } else {
      future = Future<WebRtcSessionDescription>.value(
        const WebRtcSessionDescription(type: 'offer', sdp: 'recovery-offer'),
      );
    }

    return future.whenComplete(() {
      _isRecovering = false;
    });
  }

  void complete() {
    _pending?.complete(
      const WebRtcSessionDescription(type: 'offer', sdp: 'recovery-offer'),
    );
    _pending = null;
  }
}

class _FakeOnlineAwareResilience implements IOnlineAwareResilience {
  _FakeOnlineAwareResilience({this.invokeRecoveryDuringStop = false});

  final bool invokeRecoveryDuringStop;
  OnRecoveryNeeded? _onRecoveryNeeded;
  int startCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> startMonitoring({
    required OnRecoveryNeeded onRecoveryNeeded,
    bool Function()? shouldAutoRecover,
  }) async {
    startCalls++;
    _onRecoveryNeeded = onRecoveryNeeded;
  }

  @override
  Future<void> stopMonitoring() async {
    stopCalls++;
    if (invokeRecoveryDuringStop && _onRecoveryNeeded != null) {
      await _onRecoveryNeeded!.call();
    }
    _onRecoveryNeeded = null;
  }

  @override
  Future<bool> hasInternetAccess() async => true;

  Future<void> triggerRecoveryCallback() async {
    await _onRecoveryNeeded?.call();
  }
}

Future<void> _waitForCondition(
  bool Function() predicate, {
  required String description,
  Duration timeout = const Duration(seconds: 5),
  Duration pollInterval = const Duration(milliseconds: 25),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (predicate()) {
      return;
    }
    await Future<void>.delayed(pollInterval);
  }

  fail('Timed out waiting for $description.');
}
