import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:scommconnector/features/webrtc/data/services/webrtc_peer_service.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_connection_state.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_candidate.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_data_message.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_session_description.dart';
import 'package:test/test.dart';

enum PeerSide { a, b }

Future<void> runFreshConnectionScenario({required PeerSide offerer}) async {
  final harness = _FakePeerHarness();
  final result = await _captureScenario(
    peerA: WebRtcPeerService(
      peerConnectionFactory: harness.createPeerConnectionA,
    ),
    peerB: WebRtcPeerService(
      peerConnectionFactory: harness.createPeerConnectionB,
    ),
    body: (scenario) async {
      await _connectPeers(
        scenario,
        offerer: offerer,
        channelLabel: 'test-channel',
      );

      final sentMessage = offerer == PeerSide.a
          ? 'hello-from-a'
          : 'hello-from-b';
      await _sendMessage(
        scenario,
        sender: offerer,
        channelLabel: 'test-channel',
        message: sentMessage,
      );

      await _waitForCondition(
        () => _countOpenLogs(scenario.printedLogs, 'test-channel') >= 2,
        description: 'both peers to report the data channel opening',
      );

      await Future<void>.delayed(const Duration(milliseconds: 300));
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(result.peerAStates, contains(WebRtcConnectionState.connected));
  expect(result.peerBStates, contains(WebRtcConnectionState.connected));
  expect(_errorLogs(result.printedLogs), isEmpty);
  expect(_countOpenLogs(result.printedLogs, 'test-channel'), 2);

  if (offerer == PeerSide.a) {
    expect(result.peerAMessages, isEmpty);
    expect(result.peerBMessages, hasLength(1));
    expect(result.peerBMessages.single.channelLabel, 'test-channel');
    expect(result.peerBMessages.single.message, 'hello-from-a');
  } else {
    expect(result.peerBMessages, isEmpty);
    expect(result.peerAMessages, hasLength(1));
    expect(result.peerAMessages.single.channelLabel, 'test-channel');
    expect(result.peerAMessages.single.message, 'hello-from-b');
  }
}

Future<void> runSingleBindPerLabelScenario() async {
  final harness = _FakePeerHarness();
  final result = await _captureScenario(
    peerA: WebRtcPeerService(
      peerConnectionFactory: harness.createPeerConnectionA,
    ),
    peerB: WebRtcPeerService(
      peerConnectionFactory: harness.createPeerConnectionB,
    ),
    body: (scenario) async {
      await _connectPeers(
        scenario,
        offerer: PeerSide.a,
        channelLabel: 'main-channel',
      );

      await _sendMessage(
        scenario,
        sender: PeerSide.a,
        channelLabel: 'main-channel',
        message: 'main-from-a',
      );
      await _sendMessage(
        scenario,
        sender: PeerSide.b,
        channelLabel: 'main-channel',
        message: 'main-from-b',
      );

      await _waitForCondition(
        () => _countOpenLogs(scenario.printedLogs, 'main-channel') == 2,
        description: 'exactly one open log per side for main-channel',
      );
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
  expect(_countBindLogs(result.printedLogs, 'main-channel'), 2);
  expect(_countOpenLogs(result.printedLogs, 'main-channel'), 2);
  expect(_countCloseLogs(result.printedLogs, 'main-channel'), 2);
  expect(result.peerAMessages, hasLength(1));
  expect(result.peerBMessages, hasLength(1));
  expect(result.peerAMessages.single.message, 'main-from-b');
  expect(result.peerBMessages.single.message, 'main-from-a');
}

Future<void> runCloseAndReconnectScenario() async {
  final factoryPool = _SessionPeerFactoryPool();
  final result = await _captureScenario(
    peerA: WebRtcPeerService(
      peerConnectionFactory: factoryPool.createPeerConnectionA,
    ),
    peerB: WebRtcPeerService(
      peerConnectionFactory: factoryPool.createPeerConnectionB,
    ),
    body: (scenario) async {
      await _connectPeers(
        scenario,
        offerer: PeerSide.a,
        channelLabel: 'main-channel',
      );
      await _sendMessage(
        scenario,
        sender: PeerSide.a,
        channelLabel: 'main-channel',
        message: 'before-reconnect',
      );

      await scenario.peerA.close();
      await scenario.peerB.close();

      await _waitForCondition(
        () => _countCloseLogs(scenario.printedLogs, 'main-channel') >= 2,
        description: 'the old main channel to close on both peers',
      );

      final peerAMessageCountBeforeReconnect = scenario.peerAMessages.length;
      final peerBMessageCountBeforeReconnect = scenario.peerBMessages.length;

      await _connectPeers(
        scenario,
        offerer: PeerSide.a,
        channelLabel: 'main-channel',
      );
      await _sendMessage(
        scenario,
        sender: PeerSide.a,
        channelLabel: 'main-channel',
        message: 'after-reconnect',
      );

      expect(scenario.peerAMessages.length, peerAMessageCountBeforeReconnect);
      expect(
        scenario.peerBMessages.length,
        peerBMessageCountBeforeReconnect + 1,
      );
      expect(scenario.peerBMessages.last.message, 'after-reconnect');
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
  expect(_countBindLogs(result.printedLogs, 'main-channel'), 4);
  expect(_countOpenLogs(result.printedLogs, 'main-channel'), 4);
  expect(_countCloseLogs(result.printedLogs, 'main-channel'), 4);
  expect(result.peerAMessages, isEmpty);
  expect(result.peerBMessages, hasLength(2));
  expect(result.peerBMessages.first.message, 'before-reconnect');
  expect(result.peerBMessages.last.message, 'after-reconnect');
}

Future<void> runRemotePeerIntentionalCloseFreshOfferScenario() async {
  final factoryPool = _SessionPeerFactoryPool();
  final result = await _captureScenario(
    peerA: WebRtcPeerService(
      peerConnectionFactory: factoryPool.createPeerConnectionA,
    ),
    peerB: WebRtcPeerService(
      peerConnectionFactory: factoryPool.createPeerConnectionB,
    ),
    body: (scenario) async {
      await _connectPeers(
        scenario,
        offerer: PeerSide.a,
        channelLabel: 'main-channel',
      );
      await _sendMessage(
        scenario,
        sender: PeerSide.a,
        channelLabel: 'main-channel',
        message: 'before-close',
      );

      await scenario.peerA.close();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await scenario.peerB.close();

      await _waitForStateCount(
        scenario.peerAStates,
        WebRtcConnectionState.closed,
        minimumCount: 1,
        peerName: 'Peer A',
      );
      await _waitForStateCount(
        scenario.peerBStates,
        WebRtcConnectionState.closed,
        minimumCount: 1,
        peerName: 'Peer B',
      );

      await _connectPeers(
        scenario,
        offerer: PeerSide.a,
        channelLabel: 'main-channel',
      );
      await _sendMessage(
        scenario,
        sender: PeerSide.a,
        channelLabel: 'main-channel',
        message: 'after-fresh-offer',
      );
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
  expect(result.peerAMessages, isEmpty);
  expect(result.peerBMessages, hasLength(2));
  expect(result.peerBMessages.first.message, 'before-close');
  expect(result.peerBMessages.last.message, 'after-fresh-offer');
}

Future<void> runIceCandidateQueuedUntilRemoteDescriptionScenario() async {
  final peerConnection = _InspectablePeerConnection(name: 'Solo');
  peerConnection.remotePeer = peerConnection;
  final result = await _captureSingleService(
    service: WebRtcPeerService(
      peerConnectionFactory: (_) async => peerConnection,
    ),
    body: (service, logs) async {
      await service.initialize(dataChannelLabels: const []);
      await service.addRemoteIceCandidate(
        const WebRtcIceCandidate(
          candidate: 'queued-0',
          sdpMid: 'data',
          sdpMLineIndex: 0,
        ),
      );

      expect(peerConnection.addedCandidates, isEmpty);

      await service.createAnswerForOffer(
        const WebRtcSessionDescription(type: 'offer', sdp: 'offer-sdp'),
      );

      expect(peerConnection.addedCandidates, hasLength(1));
      expect(
        peerConnection.addedCandidates.single.candidate,
        'candidate:queued-0',
      );
      expect(
        logs.any(
          (line) => line.contains('Flushing 1 pending remote ICE candidates.'),
        ),
        isTrue,
      );
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
}

Future<void> runTooManyEarlyIceCandidatesScenario() async {
  final peerConnection = _InspectablePeerConnection(name: 'Solo');
  peerConnection.remotePeer = peerConnection;
  final result = await _captureSingleService(
    service: WebRtcPeerService(
      peerConnectionFactory: (_) async => peerConnection,
    ),
    body: (service, logs) async {
      await service.initialize(dataChannelLabels: const []);

      for (var index = 0; index < 205; index++) {
        await service.addRemoteIceCandidate(
          WebRtcIceCandidate(
            candidate: 'queued-$index',
            sdpMid: 'data',
            sdpMLineIndex: 0,
          ),
        );
      }

      expect(peerConnection.addedCandidates, isEmpty);

      await service.createAnswerForOffer(
        const WebRtcSessionDescription(type: 'offer', sdp: 'offer-sdp'),
      );

      expect(peerConnection.addedCandidates, hasLength(200));
      expect(
        peerConnection.addedCandidates.first.candidate,
        'candidate:queued-5',
      );
      expect(
        peerConnection.addedCandidates.last.candidate,
        'candidate:queued-204',
      );
      expect(
        logs
            .where((line) => line.contains('Pending remote ICE overflow'))
            .length,
        5,
      );
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
}

Future<void> runStaleIceAfterConnectionResetScenario() async {
  final peerConnection = _InspectablePeerConnection(name: 'Solo');
  peerConnection.remotePeer = peerConnection;
  final result = await _captureSingleService(
    service: WebRtcPeerService(
      peerConnectionFactory: (_) async => peerConnection,
    ),
    body: (service, logs) async {
      await service.initialize(dataChannelLabels: const []);
      peerConnection.throwOnGetRemoteDescription = true;

      await service.addRemoteIceCandidate(
        const WebRtcIceCandidate(
          candidate: 'late-ice',
          sdpMid: 'data',
          sdpMLineIndex: 0,
        ),
      );

      expect(peerConnection.addedCandidates, isEmpty);
      expect(
        logs.any(
          (line) => line.contains(
            'addRemoteIceCandidate: peer connection closed during remote-description check; discarding candidate.',
          ),
        ),
        isTrue,
      );
    },
  );

  expect(
    result.uncaughtError,
    isNull,
    reason:
        'Unexpected uncaught error: ${result.uncaughtError}\n${result.uncaughtStackTrace}',
  );
  expect(_errorLogs(result.printedLogs), isEmpty);
}

class _ScenarioResult {
  _ScenarioResult({required this.peerA, required this.peerB});

  final WebRtcPeerService peerA;
  final WebRtcPeerService peerB;
  final peerAStates = <WebRtcConnectionState>[];
  final peerBStates = <WebRtcConnectionState>[];
  final peerAMessages = <WebRtcDataMessage>[];
  final peerBMessages = <WebRtcDataMessage>[];
  final printedLogs = <String>[];
  final subscriptions = <StreamSubscription<dynamic>>[];
  Object? uncaughtError;
  StackTrace? uncaughtStackTrace;
}

class _SingleServiceResult {
  _SingleServiceResult({required this.service});

  final WebRtcPeerService service;
  final printedLogs = <String>[];
  Object? uncaughtError;
  StackTrace? uncaughtStackTrace;
}

Future<_ScenarioResult> _captureScenario({
  required WebRtcPeerService peerA,
  required WebRtcPeerService peerB,
  required Future<void> Function(_ScenarioResult scenario) body,
}) async {
  final result = _ScenarioResult(peerA: peerA, peerB: peerB);

  await runZonedGuarded(
    () async {
      try {
        result.subscriptions.add(
          peerA.connectionStates.listen(result.peerAStates.add),
        );
        result.subscriptions.add(
          peerB.connectionStates.listen(result.peerBStates.add),
        );
        result.subscriptions.add(
          peerA.dataMessages.listen(result.peerAMessages.add),
        );
        result.subscriptions.add(
          peerB.dataMessages.listen(result.peerBMessages.add),
        );
        result.subscriptions.add(
          peerA.localIceCandidates.listen(
            (candidate) => unawaited(peerB.addRemoteIceCandidate(candidate)),
          ),
        );
        result.subscriptions.add(
          peerB.localIceCandidates.listen(
            (candidate) => unawaited(peerA.addRemoteIceCandidate(candidate)),
          ),
        );

        await body(result);
      } finally {
        for (final subscription in result.subscriptions) {
          await subscription.cancel();
        }
        await peerA.dispose();
        await peerB.dispose();
      }
    },
    (error, stackTrace) {
      result.uncaughtError = error;
      result.uncaughtStackTrace = stackTrace;
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        result.printedLogs.add(line);
        parent.print(zone, line);
      },
    ),
  );

  return result;
}

Future<_SingleServiceResult> _captureSingleService({
  required WebRtcPeerService service,
  required Future<void> Function(WebRtcPeerService service, List<String> logs)
  body,
}) async {
  final result = _SingleServiceResult(service: service);

  await runZonedGuarded(
    () async {
      try {
        await body(service, result.printedLogs);
      } finally {
        await service.dispose();
      }
    },
    (error, stackTrace) {
      result.uncaughtError = error;
      result.uncaughtStackTrace = stackTrace;
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        result.printedLogs.add(line);
        parent.print(zone, line);
      },
    ),
  );

  return result;
}

Future<void> _connectPeers(
  _ScenarioResult scenario, {
  required PeerSide offerer,
  required String channelLabel,
}) async {
  final peerAConnectedBefore = _countState(
    scenario.peerAStates,
    WebRtcConnectionState.connected,
  );
  final peerBConnectedBefore = _countState(
    scenario.peerBStates,
    WebRtcConnectionState.connected,
  );

  await scenario.peerA
      .initialize(
        dataChannelLabels: offerer == PeerSide.a ? [channelLabel] : const [],
      )
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Peer A initialize timed out.'),
      );
  await scenario.peerB
      .initialize(
        dataChannelLabels: offerer == PeerSide.b ? [channelLabel] : const [],
      )
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Peer B initialize timed out.'),
      );

  final initiatingPeer = offerer == PeerSide.a
      ? scenario.peerA
      : scenario.peerB;
  final answeringPeer = offerer == PeerSide.a ? scenario.peerB : scenario.peerA;

  final offer = await initiatingPeer.createOffer().timeout(
    const Duration(seconds: 10),
    onTimeout: () => throw TimeoutException('Create offer timed out.'),
  );
  final answer = await answeringPeer
      .createAnswerForOffer(offer)
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Create answer timed out.'),
      );
  await initiatingPeer
      .setRemoteAnswer(answer)
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Set remote answer timed out.'),
      );

  await _waitForStateCount(
    scenario.peerAStates,
    WebRtcConnectionState.connected,
    minimumCount: peerAConnectedBefore + 1,
    peerName: 'Peer A',
  );
  await _waitForStateCount(
    scenario.peerBStates,
    WebRtcConnectionState.connected,
    minimumCount: peerBConnectedBefore + 1,
    peerName: 'Peer B',
  );
}

Future<void> _sendMessage(
  _ScenarioResult scenario, {
  required PeerSide sender,
  required String channelLabel,
  required String message,
}) async {
  final sendingPeer = sender == PeerSide.a ? scenario.peerA : scenario.peerB;
  final receivingMessages = sender == PeerSide.a
      ? scenario.peerBMessages
      : scenario.peerAMessages;
  final beforeCount = receivingMessages.length;

  await sendingPeer
      .sendData(channelLabel: channelLabel, message: message)
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Send data timed out.'),
      );

  await _waitForCondition(
    () => receivingMessages.length == beforeCount + 1,
    description: 'the receiving peer to get one data message',
  );
}

class _FakePeerHarness {
  _FakePeerHarness()
    : peerA = _FakePeerConnection(name: 'A'),
      peerB = _FakePeerConnection(name: 'B') {
    peerA.remotePeer = peerB;
    peerB.remotePeer = peerA;
  }

  final _FakePeerConnection peerA;
  final _FakePeerConnection peerB;

  Future<RTCPeerConnection> createPeerConnectionA(
    Map<String, dynamic> configuration,
  ) async {
    peerA.configuration = configuration;
    return peerA;
  }

  Future<RTCPeerConnection> createPeerConnectionB(
    Map<String, dynamic> configuration,
  ) async {
    peerB.configuration = configuration;
    return peerB;
  }
}

class _SessionPeerFactoryPool {
  final _harnesses = <_FakePeerHarness>[];
  int _peerAFactoryIndex = 0;
  int _peerBFactoryIndex = 0;

  Future<RTCPeerConnection> createPeerConnectionA(
    Map<String, dynamic> configuration,
  ) async {
    final harness = _harnessFor(_peerAFactoryIndex++);
    harness.peerA.configuration = configuration;
    return harness.peerA;
  }

  Future<RTCPeerConnection> createPeerConnectionB(
    Map<String, dynamic> configuration,
  ) async {
    final harness = _harnessFor(_peerBFactoryIndex++);
    harness.peerB.configuration = configuration;
    return harness.peerB;
  }

  _FakePeerHarness _harnessFor(int index) {
    while (_harnesses.length <= index) {
      _harnesses.add(_FakePeerHarness());
    }
    return _harnesses[index];
  }
}

class _FakePeerConnection extends RTCPeerConnection {
  _FakePeerConnection({required this.name});

  final String name;
  late _FakePeerConnection remotePeer;

  final Map<String, _FakeDataChannel> _localDataChannels = {};
  final Map<String, _FakeDataChannel> _pendingRemoteDataChannels = {};
  final List<RTCIceCandidate> _remoteCandidates = [];

  Map<String, dynamic> configuration = const {};
  RTCSessionDescription? _localDescription;
  RTCSessionDescription? _remoteDescription;
  RTCPeerConnectionState? _connectionState =
      RTCPeerConnectionState.RTCPeerConnectionStateNew;
  RTCIceConnectionState? _iceConnectionState =
      RTCIceConnectionState.RTCIceConnectionStateNew;
  bool _closed = false;
  bool _localIceEmitted = false;
  bool _connectionOpened = false;

  @override
  RTCSignalingState? get signalingState => null;

  @override
  RTCIceGatheringState? get iceGatheringState => null;

  @override
  RTCIceConnectionState? get iceConnectionState => _iceConnectionState;

  @override
  RTCPeerConnectionState? get connectionState => _connectionState;

  @override
  Map<String, dynamic> get getConfiguration => configuration;

  @override
  Future<void> setConfiguration(Map<String, dynamic> configuration) async {
    this.configuration = configuration;
  }

  @override
  Future<RTCSessionDescription> createOffer([
    Map<String, dynamic> constraints = const {},
  ]) async {
    return RTCSessionDescription('offer-sdp-$name', 'offer');
  }

  @override
  Future<RTCSessionDescription> createAnswer([
    Map<String, dynamic> constraints = const {},
  ]) async {
    return RTCSessionDescription('answer-sdp-$name', 'answer');
  }

  @override
  Future<void> addStream(MediaStream stream) async {}

  @override
  Future<void> removeStream(MediaStream stream) async {}

  @override
  Future<RTCSessionDescription?> getLocalDescription() async {
    return _localDescription;
  }

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    _localDescription = description;
    _emitLocalIceCandidateIfNeeded();
    _maybeOpenConnection();
  }

  @override
  Future<RTCSessionDescription?> getRemoteDescription() async {
    return _remoteDescription;
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    _remoteDescription = description;
    if (description.type == 'offer') {
      _deliverPendingRemoteDataChannels();
    }
    _maybeOpenConnection();
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async {
    _remoteCandidates.add(candidate);
    _maybeOpenConnection();
  }

  @override
  Future<List<StatsReport>> getStats([MediaStreamTrack? track]) async {
    return const <StatsReport>[];
  }

  @override
  List<MediaStream?> getLocalStreams() => const <MediaStream?>[];

  @override
  List<MediaStream?> getRemoteStreams() => const <MediaStream?>[];

  @override
  Future<RTCDataChannel> createDataChannel(
    String label,
    RTCDataChannelInit dataChannelDict,
  ) async {
    return _localDataChannels.putIfAbsent(label, () {
      final localChannel = _FakeDataChannel(label: label);
      final remoteChannel = _FakeDataChannel(label: label);
      localChannel.counterpart = remoteChannel;
      remoteChannel.counterpart = localChannel;
      remotePeer._pendingRemoteDataChannels[label] = remoteChannel;
      return localChannel;
    });
  }

  @override
  Future<void> restartIce() async {
    _localIceEmitted = false;
    _emitLocalIceCandidateIfNeeded();
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateClosed;
    _iceConnectionState = RTCIceConnectionState.RTCIceConnectionStateClosed;
    onConnectionState?.call(_connectionState!);
  }

  @override
  Future<void> dispose() async {
    await close();
  }

  @override
  RTCDTMFSender createDtmfSender(MediaStreamTrack track) {
    throw UnimplementedError();
  }

  @override
  Future<List<RTCRtpSender>> getSenders() async {
    return const <RTCRtpSender>[];
  }

  @override
  Future<List<RTCRtpReceiver>> getReceivers() async {
    return const <RTCRtpReceiver>[];
  }

  @override
  Future<List<RTCRtpTransceiver>> getTransceivers() async {
    return const <RTCRtpTransceiver>[];
  }

  @override
  Future<RTCRtpSender> addTrack(MediaStreamTrack track, [MediaStream? stream]) {
    throw UnimplementedError();
  }

  @override
  Future<bool> removeTrack(RTCRtpSender sender) async {
    return true;
  }

  @override
  Future<RTCRtpTransceiver> addTransceiver({
    MediaStreamTrack? track,
    RTCRtpMediaType? kind,
    RTCRtpTransceiverInit? init,
  }) {
    throw UnimplementedError();
  }

  void _emitLocalIceCandidateIfNeeded() {
    if (_localIceEmitted || _closed) {
      return;
    }
    _localIceEmitted = true;
    onIceCandidate?.call(RTCIceCandidate('candidate:$name-host', 'data', 0));
  }

  void _deliverPendingRemoteDataChannels() {
    for (final entry in _pendingRemoteDataChannels.entries.toList()) {
      onDataChannel?.call(entry.value);
    }
  }

  void _maybeOpenConnection() {
    if (_connectionOpened || _closed || remotePeer._closed) {
      return;
    }

    final bothDescriptionsReady =
        _localDescription != null &&
        _remoteDescription != null &&
        remotePeer._localDescription != null &&
        remotePeer._remoteDescription != null;
    final bothHaveIce =
        _remoteCandidates.isNotEmpty && remotePeer._remoteCandidates.isNotEmpty;

    if (!bothDescriptionsReady || !bothHaveIce) {
      return;
    }

    _openConnectedState();
    remotePeer._openConnectedState();
  }

  void _openConnectedState() {
    if (_connectionOpened) {
      return;
    }
    _connectionOpened = true;
    _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateConnected;
    _iceConnectionState = RTCIceConnectionState.RTCIceConnectionStateConnected;
    onConnectionState?.call(_connectionState!);

    for (final label in _localDataChannels.keys) {
      _localDataChannels[label]?.open();
      remotePeer._pendingRemoteDataChannels[label]?.open();
    }
  }
}

class _FakeDataChannel extends RTCDataChannel {
  _FakeDataChannel({required String label}) : _label = label {
    stateChangeStream = _stateController.stream;
    messageStream = _messageController.stream;
  }

  final String _label;
  final StreamController<RTCDataChannelState> _stateController =
      StreamController<RTCDataChannelState>.broadcast(sync: true);
  final StreamController<RTCDataChannelMessage> _messageController =
      StreamController<RTCDataChannelMessage>.broadcast(sync: true);

  _FakeDataChannel? counterpart;
  RTCDataChannelState? _state = RTCDataChannelState.RTCDataChannelConnecting;
  bool _isClosed = false;

  @override
  RTCDataChannelState? get state => _state;

  @override
  int? get id => 1;

  @override
  String? get label => _label;

  @override
  int? get bufferedAmount => 0;

  @override
  int? bufferedAmountLowThreshold;

  @override
  Future<int> getBufferedAmount() async {
    return 0;
  }

  @override
  Future<void> send(RTCDataChannelMessage message) async {
    counterpart?._receive(message);
  }

  @override
  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    _state = RTCDataChannelState.RTCDataChannelClosed;
    onDataChannelState?.call(_state!);
    _stateController.add(_state!);
    await _stateController.close();
    await _messageController.close();
  }

  void open() {
    if (_state == RTCDataChannelState.RTCDataChannelOpen || _isClosed) {
      return;
    }
    _state = RTCDataChannelState.RTCDataChannelOpen;
    onDataChannelState?.call(_state!);
    _stateController.add(_state!);
  }

  void _receive(RTCDataChannelMessage message) {
    if (_isClosed) {
      return;
    }
    onMessage?.call(message);
    _messageController.add(message);
  }
}

class _InspectablePeerConnection extends _FakePeerConnection {
  _InspectablePeerConnection({required super.name});

  final addedCandidates = <RTCIceCandidate>[];
  bool throwOnGetRemoteDescription = false;

  @override
  Future<RTCSessionDescription?> getRemoteDescription() async {
    if (throwOnGetRemoteDescription) {
      throw StateError('peer connection closed');
    }
    return super.getRemoteDescription();
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async {
    addedCandidates.add(candidate);
    await super.addCandidate(candidate);
  }
}

Future<void> _waitForStateCount(
  List<WebRtcConnectionState> states,
  WebRtcConnectionState expected, {
  required int minimumCount,
  required String peerName,
}) {
  return _waitForCondition(
    () => _countState(states, expected) >= minimumCount,
    description: '$peerName to reach $expected $minimumCount time(s)',
  );
}

int _countState(
  List<WebRtcConnectionState> states,
  WebRtcConnectionState expected,
) {
  return states.where((state) => state == expected).length;
}

Future<void> _waitForCondition(
  bool Function() predicate, {
  required String description,
  Duration timeout = const Duration(seconds: 15),
  Duration pollInterval = const Duration(milliseconds: 50),
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

List<String> _errorLogs(List<String> printedLogs) {
  return printedLogs
      .where((line) => line.contains('ERROR ScommConnector'))
      .toList(growable: false);
}

int _countOpenLogs(List<String> printedLogs, String label) {
  return printedLogs
      .where(
        (line) =>
            line.contains('Data channel state changed label=$label') &&
            line.toLowerCase().contains('open'),
      )
      .length;
}

int _countBindLogs(List<String> printedLogs, String label) {
  return printedLogs
      .where((line) => line.contains('Binding data channel label=$label'))
      .length;
}

int _countCloseLogs(List<String> printedLogs, String label) {
  return printedLogs
      .where(
        (line) =>
            line.contains('Data channel state changed label=$label') &&
            line.toLowerCase().contains('closed'),
      )
      .length;
}
