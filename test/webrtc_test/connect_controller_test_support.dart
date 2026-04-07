import 'dart:async';

import 'package:scommconnector/features/connect/connect_controller.dart';
import 'package:scommconnector/features/signaling/application/controllers/signaling_controller.dart';
import 'package:scommconnector/features/signaling/domain/entities/signaling_entities.dart';
import 'package:scommconnector/features/webrtc/application/controllers/webrtc_controller.dart';
import 'package:scommconnector/features/webrtc/application/state/webrtc_state.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_candidate.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_session_description.dart';
import 'package:test/test.dart';

Future<void> runFreshIncomingOfferResetsOldSessionScenario() async {
  final signaling = _FakeSignalingController();
  final webrtc = _FakeWebRtcController();
  final controller = ConnectController(
    signalingController: signaling,
    webRtcController: webrtc,
  );

  try {
    await controller.start(
      deviceId: 'me',
      localUri: 'scomm:local/device_a',
      dataChannels: const ['main-channel'],
    );
    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );

    signaling.emit(
      SignalEnvelope(
        messageId: 'msg-offer-1',
        from: const SignalingDeviceRef(uri: 'scomm:remote/device_b'),
        to: const SignalingDeviceRef(uri: 'scomm:local/device_a'),
        offer: const SignalingOffer(
          requestId: 'fresh-request-2',
          sdp: 'offer-2',
        ),
      ),
    );

    await _waitForCondition(
      () => signaling.sentEnvelopes.any((envelope) => envelope.answer != null),
      description: 'an answer to be sent for the fresh offer',
    );

    expect(webrtc.closeCalls, 1);
    expect(webrtc.initializeCalls, 2);
    expect(webrtc.createAnswerCalls, 1);
    final sentAnswer = signaling.sentEnvelopes.firstWhere(
      (envelope) => envelope.answer != null,
    );
    expect(sentAnswer.answer?.requestId, 'fresh-request-2');
  } finally {
    await controller.stop();
    await signaling.dispose();
  }
}

Future<void> runIncomingOfferRetriesAfterHaveLocalOfferScenario() async {
  final signaling = _FakeSignalingController();
  final webrtc = _FakeWebRtcController()..throwHaveLocalOfferOnce = true;
  final controller = ConnectController(
    signalingController: signaling,
    webRtcController: webrtc,
  );

  try {
    await controller.start(
      deviceId: 'me',
      localUri: 'scomm:local/device_a',
      dataChannels: const ['main-channel'],
    );
    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );
    final originalRequestId = signaling.lastConnectionRequestId!;

    signaling.emit(
      SignalEnvelope(
        messageId: 'msg-offer-same-request',
        from: const SignalingDeviceRef(uri: 'scomm:remote/device_b'),
        to: const SignalingDeviceRef(uri: 'scomm:local/device_a'),
        offer: SignalingOffer(requestId: originalRequestId, sdp: 'offer-retry'),
      ),
    );

    await _waitForCondition(
      () => signaling.sentEnvelopes.any((envelope) => envelope.answer != null),
      description: 'an answer to be sent after retrying the collided offer',
    );

    expect(webrtc.createAnswerCalls, 2);
    expect(webrtc.closeCalls, 1);
    expect(webrtc.initializeCalls, 2);
  } finally {
    await controller.stop();
    await signaling.dispose();
  }
}

Future<void> runDropNewConnectionRequestWhileConnectedScenario() async {
  final signaling = _FakeSignalingController();
  final webrtc = _FakeWebRtcController();
  final controller = ConnectController(
    signalingController: signaling,
    webRtcController: webrtc,
  );

  try {
    await controller.start(
      deviceId: 'me',
      localUri: 'scomm:local/device_a',
      dataChannels: const ['main-channel'],
    );
    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );
    webrtc.stateValue = const WebRtcState(status: WebRtcStatus.connected);

    var wasDelivered = false;
    final subscription = controller.incomingConnectionRequests.listen((_) {
      wasDelivered = true;
    });
    try {
      signaling.emit(
        SignalEnvelope(
          messageId: 'msg-connection-request-new',
          from: const SignalingDeviceRef(uri: 'scomm:remote/device_b'),
          to: const SignalingDeviceRef(uri: 'scomm:local/device_a'),
          connectionRequest: const SignalingConnectionRequest(
            requestId: 'fresh-request-2',
            serviceName: 'main-channel',
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(wasDelivered, isFalse);
    } finally {
      await subscription.cancel();
    }
  } finally {
    await controller.stop();
    await signaling.dispose();
  }
}

Future<void> runDropNewIncomingOfferWhileConnectedScenario() async {
  final signaling = _FakeSignalingController();
  final webrtc = _FakeWebRtcController();
  final controller = ConnectController(
    signalingController: signaling,
    webRtcController: webrtc,
  );

  try {
    await controller.start(
      deviceId: 'me',
      localUri: 'scomm:local/device_a',
      dataChannels: const ['main-channel'],
    );
    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );
    webrtc.stateValue = const WebRtcState(status: WebRtcStatus.connected);

    signaling.emit(
      SignalEnvelope(
        messageId: 'msg-offer-new',
        from: const SignalingDeviceRef(uri: 'scomm:remote/device_b'),
        to: const SignalingDeviceRef(uri: 'scomm:local/device_a'),
        offer: const SignalingOffer(
          requestId: 'fresh-request-2',
          sdp: 'offer-2',
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(webrtc.createAnswerCalls, 0);
    expect(
      signaling.sentEnvelopes.where((envelope) => envelope.answer != null),
      isEmpty,
    );
  } finally {
    await controller.stop();
    await signaling.dispose();
  }
}

Future<void> runDropOutgoingConnectionRequestWhileConnectedScenario() async {
  final signaling = _FakeSignalingController();
  final webrtc = _FakeWebRtcController();
  final controller = ConnectController(
    signalingController: signaling,
    webRtcController: webrtc,
  );

  try {
    await controller.start(
      deviceId: 'me',
      localUri: 'scomm:local/device_a',
      dataChannels: const ['main-channel'],
    );
    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );
    webrtc.stateValue = const WebRtcState(status: WebRtcStatus.connected);
    final requestCallsBefore = signaling.sendConnectionRequestCalls;
    final offerCallsBefore = webrtc.createOfferCalls;

    await controller.initiateConnection(
      toUri: 'scomm:remote/device_b',
      serviceName: 'main-channel',
    );

    expect(signaling.sendConnectionRequestCalls, requestCallsBefore);
    expect(webrtc.createOfferCalls, offerCallsBefore);
  } finally {
    await controller.stop();
    await signaling.dispose();
  }
}

class _FakeSignalingController implements SignalingController {
  final _incomingController = StreamController<SignalEnvelope>.broadcast();
  final sentEnvelopes = <SignalEnvelope>[];
  String? lastConnectionRequestId;
  int sendConnectionRequestCalls = 0;

  void emit(SignalEnvelope envelope) {
    _incomingController.add(envelope);
  }

  Future<void> dispose() async {
    await _incomingController.close();
  }

  @override
  Stream<SignalEnvelope> get incomingMessages => _incomingController.stream;

  @override
  Future<void> start({required String deviceId}) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> sendConnectionRequest({
    required String requestId,
    required String fromUri,
    required String toUri,
    required String serviceName,
    String note = '',
    Duration timeout = const Duration(seconds: 12),
  }) async {
    sendConnectionRequestCalls++;
    lastConnectionRequestId = requestId;
  }

  @override
  Future<void> sendEnvelope(SignalEnvelope envelope) async {
    sentEnvelopes.add(envelope);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeWebRtcController implements WebRtcController {
  final _localIceController = StreamController<WebRtcIceCandidate>.broadcast();
  int initializeCalls = 0;
  int closeCalls = 0;
  int createOfferCalls = 0;
  int createAnswerCalls = 0;
  bool throwHaveLocalOfferOnce = false;
  WebRtcState stateValue = const WebRtcState(status: WebRtcStatus.negotiating);

  @override
  WebRtcState get state => stateValue;

  @override
  Stream<WebRtcIceCandidate> get localIceCandidates =>
      _localIceController.stream;

  @override
  Future<void> initialize({
    required List<String> dataChannels,
    List<WebRtcIceServerConfig>? iceServers,
  }) async {
    initializeCalls++;
  }

  @override
  Future<void> close() async {
    closeCalls++;
  }

  @override
  Future<WebRtcSessionDescription> createOffer({
    bool iceRestart = false,
  }) async {
    createOfferCalls++;
    return const WebRtcSessionDescription(type: 'offer', sdp: 'local-offer');
  }

  @override
  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  ) async {
    createAnswerCalls++;
    if (throwHaveLocalOfferOnce) {
      throwHaveLocalOfferOnce = false;
      throw StateError(
        'Unable to RTCPeerConnection::setRemoteDescription: Failed to set remote offer sdp: Called in wrong state: have-local-offer',
      );
    }
    return const WebRtcSessionDescription(type: 'answer', sdp: 'local-answer');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
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
