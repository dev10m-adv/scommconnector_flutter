import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../core/logging/log.dart';
import '../../domain/entities/webrtc_connection_state.dart';
import '../../domain/entities/webrtc_data_message.dart';
import '../../domain/entities/webrtc_ice_candidate.dart';
import '../../domain/entities/webrtc_ice_route.dart';
import '../../domain/entities/webrtc_ice_server_config.dart';
import '../../domain/entities/webrtc_session_description.dart';
import 'webrtc_ice_route_stats_parser.dart';

typedef WebRtcPeerConnectionFactory =
    Future<RTCPeerConnection> Function(Map<String, dynamic> configuration);

class WebRtcPeerService {
  WebRtcPeerService({WebRtcPeerConnectionFactory? peerConnectionFactory})
    : _peerConnectionFactory =
          peerConnectionFactory ??
          ((configuration) => createPeerConnection(configuration));

  static const _maxPendingRemoteIceCandidates = 200;

  final WebRtcPeerConnectionFactory _peerConnectionFactory;
  final WebRtcIceRouteStatsParser _iceRouteStatsParser =
      const WebRtcIceRouteStatsParser();
  RTCPeerConnection? _peerConnection;
  final Map<String, RTCDataChannel> _dataChannels = {};
  final List<WebRtcIceCandidate> _pendingRemoteIceCandidates = [];
  Timer? _iceRoutePollTimer;
  bool _iceRouteRefreshInFlight = false;
  WebRtcIceRoute _iceRoute = const WebRtcIceRoute();

  final _connectionStateController =
      StreamController<WebRtcConnectionState>.broadcast();
  final _localIceController = StreamController<WebRtcIceCandidate>.broadcast();
  final _iceRouteController = StreamController<WebRtcIceRoute>.broadcast();
  final _dataMessageController =
      StreamController<WebRtcDataMessage>.broadcast();

  Stream<WebRtcConnectionState> get connectionStates =>
      _connectionStateController.stream;
  Stream<WebRtcIceCandidate> get localIceCandidates =>
      _localIceController.stream;
  Stream<WebRtcIceRoute> get iceRoutes => _iceRouteController.stream;
  Stream<WebRtcDataMessage> get dataMessages => _dataMessageController.stream;
  WebRtcIceRoute get iceRoute => _iceRoute;

  Future<void> initialize({
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  }) async {
    infoLog(
      'Initializing WebRTC peer service with ${dataChannelLabels.length} data channels.',
    );
    await close();

    final config = <String, dynamic>{
      'iceServers': _buildIceServers(iceServers),
    };

    final pc = await _peerConnectionFactory(config);
    _peerConnection = pc;

    pc.onConnectionState = (state) {
      debugLog('PeerConnection state changed to $state.');
      _connectionStateController.add(_mapConnectionState(state));
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
        unawaited(refreshIceRoute());
      }
    };

    pc.onIceConnectionState = (state) {
      debugLog('ICE connection state changed to $state.');
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        warningLog('ICE connection entered failed state.');
        _connectionStateController.add(WebRtcConnectionState.failed);
      }
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        warningLog('ICE connection entered disconnected state.');
        _connectionStateController.add(WebRtcConnectionState.disconnected);
      }
      unawaited(refreshIceRoute());
    };

    pc.onIceCandidate = (candidate) {
      final raw = candidate.candidate;
      if (raw == null || raw.isEmpty) {
        return;
      }
      debugLog('Generated local ICE candidate with mid=${candidate.sdpMid}.');
      _localIceController.add(
        WebRtcIceCandidate(
          candidate: _candidateToSignal(raw),
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ),
      );
    };

    pc.onDataChannel = (channel) {
      infoLog('Received remote data channel label=${channel.label}.');
      _bindDataChannel(channel);
    };

    for (final label in dataChannelLabels) {
      await addDataChannel(label);
    }

    _startIceRoutePolling();
    _emitIceRoute(const WebRtcIceRoute());
  }

  Future<WebRtcSessionDescription> createOffer({
    bool iceRestart = false,
  }) async {
    final pc = _requirePeerConnection();

    debugLog('Creating WebRTC offer. iceRestart=$iceRestart.');

    if (iceRestart) {
      await pc.restartIce();
    }
    final offer = iceRestart
        ? await pc.createOffer(const {'iceRestart': true})
        : await pc.createOffer();
    await pc.setLocalDescription(offer);

    return WebRtcSessionDescription(
      type: offer.type ?? 'offer',
      sdp: offer.sdp ?? '',
    );
  }

  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  ) async {
    infoLog('Creating answer for remote offer type=${offer.type}.');
    final pc = _requirePeerConnection();

    try {
      await pc.setRemoteDescription(
        RTCSessionDescription(offer.sdp, offer.type),
      );
    } catch (error, stackTrace) {
      errorLog(
        'Failed to set remote description for offer.',
        error,
        stackTrace,
      );
      rethrow;
    }
    await _flushPendingRemoteIceCandidates(pc);

    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);

    return WebRtcSessionDescription(
      type: answer.type ?? 'answer',
      sdp: answer.sdp ?? '',
    );
  }

  Future<void> setRemoteAnswer(WebRtcSessionDescription answer) async {
    final pc = _requirePeerConnection();
    debugLog('Applying remote answer type=${answer.type}.');
    await pc.setRemoteDescription(
      RTCSessionDescription(answer.sdp, answer.type),
    );
    await _flushPendingRemoteIceCandidates(pc);
  }

  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) async {
    final pc = _requirePeerConnection();

    // Guard: getRemoteDescription() throws a PlatformException if the native
    // peer connection was closed between _requirePeerConnection() and here
    // (race condition during reconnect / navigation). The candidate is no
    // longer applicable – discard it silently.
    bool hasRemoteDescription;
    try {
      hasRemoteDescription = (await pc.getRemoteDescription()) != null;
    } catch (_) {
      warningLog(
        'addRemoteIceCandidate: peer connection closed during remote-description check; discarding candidate.',
      );
      return;
    }

    if (!hasRemoteDescription) {
      if (_pendingRemoteIceCandidates.length >=
          _maxPendingRemoteIceCandidates) {
        final dropped = _pendingRemoteIceCandidates.removeAt(0);
        warningLog(
          'Pending remote ICE overflow; dropping oldest candidate mid=${dropped.sdpMid} mline=${dropped.sdpMLineIndex}.',
        );
      }
      _pendingRemoteIceCandidates.add(candidate);
      debugLog(
        'Queued remote ICE candidate before remote description. pending=${_pendingRemoteIceCandidates.length}.',
      );
      return;
    }

    await _applyRemoteIceCandidate(pc, candidate);
  }

  Future<void> addDataChannel(String label) async {
    final pc = _requirePeerConnection();

    if (_dataChannels.containsKey(label)) {
      debugLog('Skipping addDataChannel for existing label=$label.');
      return;
    }

    final channel = await _createDataChannelWhenReady(pc, label);
    infoLog('Created local data channel label=$label.');
    _bindDataChannel(channel);
  }

  Future<void> removeDataChannel(String label) async {
    final channel = _dataChannels.remove(label);
    if (channel == null) {
      debugLog('removeDataChannel ignored for missing label=$label.');
      return;
    }
    infoLog('Closing data channel label=$label.');
    await channel.close();
  }

  Future<void> sendData({
    required String channelLabel,
    required String message,
  }) async {
    final channel = _dataChannels[channelLabel];
    if (channel == null) {
      throw StateError('Data channel "$channelLabel" does not exist.');
    }

    await channel.send(RTCDataChannelMessage(message));
  }

  Future<WebRtcIceRoute> refreshIceRoute() async {
    final pc = _peerConnection;
    if (pc == null) {
      _emitIceRoute(const WebRtcIceRoute());
      return _iceRoute;
    }
    if (_iceRouteRefreshInFlight) {
      return _iceRoute;
    }

    _iceRouteRefreshInFlight = true;
    try {
      final reports = await pc.getStats();
      final next = _iceRouteStatsParser.parse(reports);
      _emitIceRoute(next);
      return next;
    } catch (error, stackTrace) {
      debugLog('Unable to refresh ICE route from stats: $error');
      errorLog('ICE route stats refresh failed.', error, stackTrace);
      return _iceRoute;
    } finally {
      _iceRouteRefreshInFlight = false;
    }
  }

  Future<WebRtcSessionDescription> restartIceAndCreateOffer() {
    return createOffer(iceRestart: true);
  }

  Future<void> close() async {
    infoLog('Closing WebRTC peer service. channels=${_dataChannels.length}.');
    _iceRoutePollTimer?.cancel();
    _iceRoutePollTimer = null;
    for (final channel in _dataChannels.values) {
      await channel.close();
    }
    _dataChannels.clear();
    _pendingRemoteIceCandidates.clear();

    final pc = _peerConnection;
    _peerConnection = null;
    if (pc != null) {
      await pc.close();
      await pc.dispose();
    }

    _emitIceRoute(const WebRtcIceRoute());
    _connectionStateController.add(WebRtcConnectionState.closed);
    debugLog('WebRTC peer service closed.');
  }

  Future<void> dispose() async {
    await close();
    await _connectionStateController.close();
    await _localIceController.close();
    await _iceRouteController.close();
    await _dataMessageController.close();
  }

  RTCPeerConnection _requirePeerConnection() {
    final pc = _peerConnection;
    if (pc == null) {
      throw StateError('PeerConnection is not initialized.');
    }
    return pc;
  }

  List<Map<String, dynamic>> _buildIceServers(
    List<WebRtcIceServerConfig>? input,
  ) {
    if (input != null && input.isNotEmpty) {
      return input
          .map(
            (entry) => <String, dynamic>{
              'urls': entry.urls,
              if (entry.username != null) 'username': entry.username,
              if (entry.credential != null) 'credential': entry.credential,
            },
          )
          .toList(growable: false);
    }

    return const <Map<String, dynamic>>[
      <String, dynamic>{
        'urls': ['stun:stun.l.google.com:19302'],
      },
    ];
  }

  WebRtcConnectionState _mapConnectionState(RTCPeerConnectionState state) {
    switch (state) {
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
        return WebRtcConnectionState.newState;
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        return WebRtcConnectionState.connecting;
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        return WebRtcConnectionState.connected;
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        return WebRtcConnectionState.disconnected;
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        return WebRtcConnectionState.failed;
      case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        return WebRtcConnectionState.closed;
    }
  }

  String _candidateToSignal(String rawCandidate) {
    return rawCandidate.startsWith('candidate:')
        ? rawCandidate
        : 'candidate:$rawCandidate';
  }

  RTCIceCandidate _toFlutterCandidate(
    String rawCandidate, {
    String? sdpMid,
    int? sdpMLineIndex,
  }) {
    return RTCIceCandidate(
      _candidateToSignal(rawCandidate),
      sdpMid,
      sdpMLineIndex,
    );
  }

  Future<void> _applyRemoteIceCandidate(
    RTCPeerConnection pc,
    WebRtcIceCandidate candidate,
  ) async {
    debugLog(
      'Applying remote ICE candidate mid=${candidate.sdpMid} mline=${candidate.sdpMLineIndex}.',
    );
    final parsed = _toFlutterCandidate(
      candidate.candidate,
      sdpMid: candidate.sdpMid,
      sdpMLineIndex: candidate.sdpMLineIndex,
    );
    await pc.addCandidate(parsed);
  }

  Future<void> _flushPendingRemoteIceCandidates(RTCPeerConnection pc) async {
    if (_pendingRemoteIceCandidates.isEmpty) {
      return;
    }

    final pending = List<WebRtcIceCandidate>.from(_pendingRemoteIceCandidates);
    _pendingRemoteIceCandidates.clear();
    infoLog('Flushing ${pending.length} pending remote ICE candidates.');

    for (final candidate in pending) {
      await _applyRemoteIceCandidate(pc, candidate);
    }
  }

  Future<RTCDataChannel> _createDataChannelWhenReady(
    RTCPeerConnection pc,
    String label,
  ) async {
    return pc.createDataChannel(label, RTCDataChannelInit());
  }

  void _bindDataChannel(RTCDataChannel channel) {
    final label = channel.label;
    if (label == null) {
      warningLog('Ignoring data channel with null label.');
      return;
    }
    _dataChannels[label] = channel;
    infoLog('Binding data channel label=$label state=${channel.state}.');

    channel.stateChangeStream.listen((state) {
      infoLog('Data channel state changed label=$label state=$state.');
    });

    channel.messageStream.listen((data) {
      final value = data.isBinary
          ? String.fromCharCodes(data.binary)
          : data.text;
      debugLog(
        'Data channel message received label=$label bytes=${value.length}.',
      );
      _dataMessageController.add(
        WebRtcDataMessage(channelLabel: label, message: value),
      );
    });
  }

  void _startIceRoutePolling() {
    _iceRoutePollTimer?.cancel();
    _iceRoutePollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      unawaited(refreshIceRoute());
    });
  }

  void _emitIceRoute(WebRtcIceRoute next) {
    if (_iceRoute == next) {
      return;
    }
    _iceRoute = next;
    if (!_iceRouteController.isClosed) {
      _iceRouteController.add(next);
    }
  }
}
