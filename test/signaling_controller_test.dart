import 'dart:async';

import 'package:scommconnector/core/errors/app_exceptions.dart';
import 'package:scommconnector/core/resilience/online_aware_resilience.dart';
import 'package:scommconnector/features/signaling/application/controllers/signaling_controller.dart';
import 'package:scommconnector/features/signaling/application/state/signaling_state.dart';
import 'package:scommconnector/features/signaling/domain/entities/signaling_entities.dart';
import 'package:scommconnector/features/signaling/domain/repositories/signaling_repository.dart';
import 'package:scommconnector/features/signaling/domain/services/connection_health_monitor.dart';
import 'package:scommconnector/features/signaling/domain/services/request_matcher.dart';
import 'package:scommconnector/features/signaling/domain/services/signaling_error_classifier.dart';
import 'package:scommconnector/features/signaling/domain/usecases/connect_signaling_usecase.dart';
import 'package:scommconnector/features/signaling/domain/usecases/disconnect_signaling_usecase.dart';
import 'package:scommconnector/features/signaling/domain/usecases/send_signal_envelope_usecase.dart';
import 'package:scommconnector/features/signaling/domain/usecases/watch_connection_status_usecase.dart';
import 'package:scommconnector/features/signaling/domain/usecases/watch_presence_usecase.dart';
import 'package:scommconnector/features/signaling/domain/usecases/watch_signaling_messages_uscase.dart';
import 'package:test/test.dart';

void main() {
  group('SignalingController.start', () {
    test('does not report connected before startup pong arrives', () async {
      final repository = _FakeSignalingRepository();
      final healthMonitor = _FakeConnectionHealthMonitor();
      final controller = _buildController(
        repository: repository,
        healthMonitor: healthMonitor,
      );
      final states = <SignalingState>[];
      final sub = controller.signalingStates.listen(states.add);

      addTearDown(() async {
        await sub.cancel();
        await controller.dispose();
      });

      final startFuture = controller.start(deviceId: 'device-1');

      await pumpEventQueue();

      expect(states, isNotEmpty);
      expect(states.last.status, SignalingStatus.connecting);
      expect(
        states.where((state) => state.status == SignalingStatus.connected),
        isEmpty,
      );

      final startupPing = repository.sentEnvelopes.singleWhere(
        (envelope) => envelope.payloadType == SignalingPayloadType.ping,
      );

      repository.emit(
        SignalingEnvelope(
          messageId: startupPing.messageId,
          pongTimestampMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      await startFuture;

      expect(states.last.status, SignalingStatus.connected);
      expect(healthMonitor.isActive, isTrue);
    });

    test(
      'fails without reporting connected when the stream errors early',
      () async {
        final repository = _FakeSignalingRepository();
        final controller = _buildController(repository: repository);
        final states = <SignalingState>[];
        final sub = controller.signalingStates.listen(states.add);

        addTearDown(() async {
          await sub.cancel();
          await controller.dispose();
        });

        final startFuture = controller.start(deviceId: 'device-1');

        await pumpEventQueue();
        repository.fail(
          const NoConnectionException(
            message: 'Signaling server is not reachable.',
          ),
        );

        await expectLater(startFuture, throwsA(isA<NoConnectionException>()));
        await Future<void>.delayed(Duration.zero);

        expect(
          states.where((state) => state.status == SignalingStatus.connected),
          isEmpty,
        );
        expect(states.last.status, SignalingStatus.failure);
        expect(states.last.error, 'Signaling server is not reachable.');
      },
    );
  });
}

SignalingController _buildController({
  required _FakeSignalingRepository repository,
  _FakeConnectionHealthMonitor? healthMonitor,
}) {
  return SignalingController(
    connectSignalingUseCase: ConnectSignalingUseCase(repository),
    disconnectSignalingUseCase: DisconnectSignalingUseCase(repository),
    sendSignalEnvelopeUseCase: SendSignalEnvelopeUseCase(repository),
    watchConnectionStatusUseCase: WatchConnectionStatusUseCase(repository),
    watchSignalingMessagesUseCase: WatchSignalingMessagesUseCase(repository),
    watchPresenceUseCase: WatchPresenceUseCase(repository),
    healthMonitor: healthMonitor ?? _FakeConnectionHealthMonitor(),
    errorClassifier: SignalingErrorClassifier(),
    onlineAwareness: _FakeOnlineAwareResilience(),
    requestMatcher: _FakeRequestMatcher(),
  );
}

class _FakeSignalingRepository implements SignalingRepository {
  final StreamController<SignalingEnvelope> _controller =
      StreamController<SignalingEnvelope>.broadcast();
  final List<SignalEnvelope> sentEnvelopes = <SignalEnvelope>[];

  @override
  Future<Stream<SignalingEnvelope>> connect({required String deviceId}) async {
    return _controller.stream;
  }

  @override
  Future<void> disconnect() async {
    await _controller.close();
  }

  void emit(SignalingEnvelope envelope) {
    _controller.add(envelope);
  }

  void fail(Object error) {
    _controller.addError(error);
  }

  @override
  Future<void> sendEnvelope(SignalEnvelope envelope) async {
    sentEnvelopes.add(envelope);
  }

  @override
  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  }) {
    return const Stream<SignalingPresenceEvent>.empty();
  }
  
  @override
  // TODO: implement connectionStatus
  Stream<SignalingConnectionStatus> get connectionStatus => throw UnimplementedError();
  
  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement messages
  Stream<SignalingEnvelope> get messages => throw UnimplementedError();
}

class _FakeConnectionHealthMonitor implements IConnectionHealthMonitor {
  bool _isActive = false;

  @override
  bool get isActive => _isActive;

  @override
  void startHeartbeat({
    required Duration interval,
    required SendHeartbeatCallback onSendHeartbeat,
  }) {
    _isActive = true;
  }

  @override
  Future<void> stopHeartbeat() async {
    _isActive = false;
  }
}

class _FakeOnlineAwareResilience implements IOnlineAwareResilience {
  @override
  Future<bool> hasInternetAccess() async => true;

  @override
  Future<void> startMonitoring({
    required OnRecoveryNeeded onRecoveryNeeded,
    bool Function()? shouldAutoRecover,
  }) async {}

  @override
  Future<void> stopMonitoring() async {}
}

class _FakeRequestMatcher implements IRequestMatcher {
  final Map<String, Completer<SignalingConnectionResponse>> _requests =
      <String, Completer<SignalingConnectionResponse>>{};

  @override
  void clearAllRequests() {
    _requests.clear();
  }

  @override
  bool completeRequest(String requestId, SignalingConnectionResponse response) {
    final completer = _requests.remove(requestId);
    if (completer == null || completer.isCompleted) {
      return false;
    }
    completer.complete(response);
    return true;
  }

  @override
  bool failRequest(String requestId, Object error) {
    final completer = _requests.remove(requestId);
    if (completer == null || completer.isCompleted) {
      return false;
    }
    completer.completeError(error);
    return true;
  }

  @override
  Set<String> getPendingRequestIds() => _requests.keys.toSet();

  @override
  Completer<SignalingConnectionResponse> registerRequest(String requestId) {
    final completer = Completer<SignalingConnectionResponse>();
    _requests[requestId] = completer;
    return completer;
  }
}
