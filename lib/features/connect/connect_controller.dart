import 'dart:async';

import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';

import '../signaling/application/controllers/signaling_controller.dart';
import '../signaling/domain/entities/signaling_entities.dart';
import '../webrtc/application/controllers/webrtc_controller.dart';
import '../webrtc/application/state/webrtc_state.dart';
import '../webrtc/domain/entities/webrtc_ice_candidate.dart';
import '../webrtc/domain/entities/webrtc_session_description.dart';

class ConnectController {
  final SignalingController signalingController;
  final WebRtcController webRtcController;
  ConnectController({
    required this.signalingController,
    required this.webRtcController,
  });

  StreamSubscription<SignalEnvelope>? _signalingSubscription;
  StreamSubscription<WebRtcIceCandidate>? _localIceSubscription;
  String? _localUri;
  String? _remoteUri;
  String? _activeRequestId;
  List<String> _configuredDataChannels = const [];
  List<WebRtcIceServerConfig> _configuredIceServers = const [];
  int _webrtcSessionGeneration = 0;

  final _incomingConnectionRequests =
      StreamController<SignalEnvelope>.broadcast();
  Stream<SignalEnvelope> get incomingConnectionRequests =>
      _incomingConnectionRequests.stream;

  bool _isSignalingStart = false;

  Future<void> start({
    required String deviceId,
    required String localUri,
    required List<String> dataChannels,
    List<WebRtcIceServerConfig> iceServers = const [],
  }) async {
    _localUri = localUri;
    _configuredDataChannels = List<String>.from(dataChannels);
    _configuredIceServers = List<WebRtcIceServerConfig>.from(iceServers);
    if (_isSignalingStart) {
      print('Signaling stack is already started.');
      return;
    }
    try {
      _isSignalingStart = true;
      await signalingController.start(deviceId: deviceId);

      // Attach incoming signaling listener immediately so early envelopes
      // (like connection requests) are not dropped while WebRTC initializes.
      await _signalingSubscription?.cancel();
      _signalingSubscription = signalingController.incomingMessages.listen(
        (envelope) => _handleSignalingEnvelope(envelope),
        onError: (error, stackTrace) {
          // Log error but don't crash the stream
          print('Error handling signaling envelope: $error');
        },
      );

      await _initializeWebRtcSession(reason: 'start');

      await _localIceSubscription?.cancel();
      _localIceSubscription = webRtcController.localIceCandidates.listen(
        _forwardLocalIceCandidate,
        onError: (error, stackTrace) {
          print('Error forwarding ICE candidate: $error');
        },
      );
    } catch (error) {
      // Rollback: if WebRTC init fails after signaling started, stop signaling
      _isSignalingStart = false;
      await signalingController.stop();
      rethrow;
    }
  }

  Future<void> stop() async {
    await _signalingSubscription?.cancel();
    await _localIceSubscription?.cancel();

    _signalingSubscription = null;
    _localIceSubscription = null;

    _activeRequestId = null;
    _remoteUri = null;

    await webRtcController.close();
    await signalingController.stop();
    _isSignalingStart = false;
  }

  Future<void> initiateConnection({
    required String toUri,
    required String serviceName,
    String note = '',
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (_shouldDropOutgoingRequest(toUri: toUri)) {
      print(
        'Dropping outgoing connection request to $toUri because WebRTC is already connected for activeRequestId=$_activeRequestId remoteUri=$_remoteUri.',
      );
      return;
    }

    final fromUri = _requireLocalUri();
    final requestId = _buildRequestId();

    await signalingController.sendConnectionRequest(
      requestId: requestId,
      fromUri: fromUri,
      toUri: toUri,
      serviceName: serviceName,
      note: note,
      timeout: timeout,
    );
    print(
      "Sent connection request from $fromUri to $toUri with requestId $requestId",
    );

    _remoteUri = toUri;
    _activeRequestId = requestId;

    final offer = await webRtcController.createOffer();
    await _sendOffer(offer: offer, toUri: toUri, requestId: requestId);
  }

  Future<void> acceptIncomingRequest({
    required SignalEnvelope requestEnvelope,
    required bool accept,
    String reason = '',
  }) async {
    final fromUri = _requireLocalUri();
    final toUri = requestEnvelope.from?.uri;
    final request = requestEnvelope.connectionRequest;
    if (toUri == null || request == null) {
      throw StateError(
        'Incoming request is missing from uri or request payload.',
      );
    }
    final requestId = request.requestId;

    await signalingController.sendEnvelope(
      SignalEnvelope(
        messageId: _buildRequestId(),
        from: SignalingDeviceRef(uri: fromUri),
        to: SignalingDeviceRef(uri: toUri),
        connectionResponse: SignalingConnectionResponse(
          requestId: requestId,
          status: accept
              ? SignalingConnectionResponseStatus.accepted
              : SignalingConnectionResponseStatus.rejected,
          reason: reason,
        ),
      ),
    );

    if (accept) {
      _remoteUri = toUri;
      _activeRequestId = requestId;
    }
  }

  Future<void> _handleSignalingEnvelope(SignalEnvelope envelope) async {
    try {
      switch (envelope.payloadType) {
        case SignalingPayloadType.connectionRequest:
          final connectionRequest = envelope.connectionRequest;
          final requestRemoteUri = envelope.from?.uri;
          if (connectionRequest != null &&
              requestRemoteUri != null &&
              _shouldDropIncomingRequest(
                remoteUri: requestRemoteUri,
                requestId: connectionRequest.requestId,
              )) {
            print(
              'Dropping incoming connection request from $requestRemoteUri requestId=${connectionRequest.requestId} because WebRTC is already connected for activeRequestId=$_activeRequestId remoteUri=$_remoteUri.',
            );
            break;
          }
          _incomingConnectionRequests.add(envelope);
          break;

        case SignalingPayloadType.offer:
          final remoteOffer = envelope.offer;
          print(
            'Received offer from ${envelope.from?.uri} with requestId ${remoteOffer?.requestId}',
          );
          if (remoteOffer == null) {
            break;
          }
          final offer = WebRtcSessionDescription(
            type: 'offer',
            sdp: remoteOffer.sdp,
          );

          final remoteUri = envelope.from?.uri;
          final requestId = remoteOffer.requestId;
          if (remoteUri == null || requestId.isEmpty) {
            break;
          }

          if (_shouldDropIncomingRequest(
            remoteUri: remoteUri,
            requestId: requestId,
          )) {
            print(
              'Dropping incoming offer from $remoteUri requestId=$requestId because WebRTC is already connected for activeRequestId=$_activeRequestId remoteUri=$_remoteUri.',
            );
            break;
          }

          print(
            'Incoming offer context: currentRequestId=$_activeRequestId currentRemoteUri=$_remoteUri incomingRequestId=$requestId incomingRemoteUri=$remoteUri webrtcSessionGeneration=$_webrtcSessionGeneration',
          );

          await _prepareForIncomingOffer(
            remoteUri: remoteUri,
            requestId: requestId,
          );

          final answer = await _createAnswerForIncomingOffer(offer);
          print("Created Answer for offer with requestId ${answer.type}");
          await _sendAnswer(
            answer: answer,
            toUri: _remoteUri!,
            requestId: _activeRequestId!,
          );
          break;

        case SignalingPayloadType.answer:
          final remoteAnswer = envelope.answer;
          if (remoteAnswer == null) {
            break;
          }
          final answer = WebRtcSessionDescription(
            type: 'answer',
            sdp: remoteAnswer.sdp,
          );
          await webRtcController.setRemoteAnswer(answer);
          break;

        case SignalingPayloadType.iceCandidate:
          final remoteIce = envelope.iceCandidate;
          if (remoteIce == null) {
            break;
          }
          await webRtcController.addRemoteIceCandidate(
            WebRtcIceCandidate(
              candidate: remoteIce.candidate,
              sdpMid: remoteIce.sdpMid,
              sdpMLineIndex: remoteIce.sdpMLineIndex,
            ),
          );
          break;
        case SignalingPayloadType.connectionResponse:
          // Connection response is handled at a higher level (e.g. TestingLabController)
          break;
        case SignalingPayloadType.ping:
        case SignalingPayloadType.pong:
          // Heartbeat messages - can be used for connection health monitoring
          break;

        default:
          print('Received unsupported signaling envelope: $envelope');
          break;
      }
    } catch (e) {
      print(
        'Error handling signaling envelope: payload=${envelope.payloadType} activeRequestId=$_activeRequestId remoteUri=$_remoteUri webrtcSessionGeneration=$_webrtcSessionGeneration error=$e',
      );
    }
  }

  Future<void> _forwardLocalIceCandidate(WebRtcIceCandidate candidate) async {
    final localUri = _localUri;
    final remoteUri = _remoteUri;
    final requestId = _activeRequestId;

    if (localUri == null || remoteUri == null || requestId == null) {
      return;
    }

    await signalingController.sendEnvelope(
      SignalEnvelope(
        messageId: _buildRequestId(),
        from: SignalingDeviceRef(uri: localUri),
        to: SignalingDeviceRef(uri: remoteUri),
        iceCandidate: SignalingIceCandidate(
          requestId: requestId,
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid ?? '',
          sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
        ),
      ),
    );
  }

  Future<void> _sendOffer({
    required WebRtcSessionDescription offer,
    required String toUri,
    required String requestId,
  }) {
    return signalingController.sendEnvelope(
      SignalEnvelope(
        messageId: _buildRequestId(),
        from: SignalingDeviceRef(uri: _requireLocalUri()),
        to: SignalingDeviceRef(uri: toUri),
        offer: SignalingOffer(requestId: requestId, sdp: offer.sdp),
      ),
    );
  }

  Future<void> _sendAnswer({
    required WebRtcSessionDescription answer,
    required String toUri,
    required String requestId,
  }) {
    return signalingController.sendEnvelope(
      SignalEnvelope(
        messageId: _buildRequestId(),
        from: SignalingDeviceRef(uri: _requireLocalUri()),
        to: SignalingDeviceRef(uri: toUri),
        answer: SignalingAnswer(requestId: requestId, sdp: answer.sdp),
      ),
    );
  }

  String _requireLocalUri() {
    final localUri = _localUri;
    if (localUri == null || localUri.isEmpty) {
      throw StateError('Local URI is not initialized.');
    }
    return localUri;
  }

  String _buildRequestId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  Future<void> _prepareForIncomingOffer({
    required String remoteUri,
    required String requestId,
  }) async {
    final isFreshRemoteSession =
        _activeRequestId != null &&
        (_activeRequestId != requestId || _remoteUri != remoteUri);

    print(
      'Preparing incoming offer: activeRequestId=$_activeRequestId activeRemoteUri=$_remoteUri incomingRequestId=$requestId incomingRemoteUri=$remoteUri isFreshRemoteSession=$isFreshRemoteSession webrtcSessionGeneration=$_webrtcSessionGeneration',
    );

    if (isFreshRemoteSession) {
      print(
        'Resetting WebRTC session for fresh incoming offer requestId $requestId.',
      );
      await _resetWebRtcSession();
    }

    _remoteUri = remoteUri;
    _activeRequestId = requestId;
  }

  Future<WebRtcSessionDescription> _createAnswerForIncomingOffer(
    WebRtcSessionDescription offer,
  ) async {
    try {
      print(
        'Creating answer for incoming offer on webrtcSessionGeneration=$_webrtcSessionGeneration activeRequestId=$_activeRequestId remoteUri=$_remoteUri',
      );
      return await webRtcController.createAnswerForOffer(offer);
    } catch (error) {
      print(
        'createAnswerForIncomingOffer failed on webrtcSessionGeneration=$_webrtcSessionGeneration activeRequestId=$_activeRequestId remoteUri=$_remoteUri error=$error',
      );

      if (!_isHaveLocalOfferError(error)) {
        rethrow;
      }

      print(
        'Incoming offer collided with a pending local offer. Resetting WebRTC session and retrying. activeRequestId=$_activeRequestId remoteUri=$_remoteUri webrtcSessionGeneration=$_webrtcSessionGeneration',
      );
      await _resetWebRtcSession();
      print(
        'Retrying createAnswerForOffer after reset on webrtcSessionGeneration=$_webrtcSessionGeneration activeRequestId=$_activeRequestId remoteUri=$_remoteUri',
      );
      return webRtcController.createAnswerForOffer(offer);
    }
  }

  Future<void> _resetWebRtcSession() async {
    final nextGeneration = _webrtcSessionGeneration + 1;
    print(
      'Resetting WebRTC session: previousGeneration=$_webrtcSessionGeneration nextGeneration=$nextGeneration activeRequestId=$_activeRequestId remoteUri=$_remoteUri dataChannels=${_configuredDataChannels.length} iceServers=${_configuredIceServers.length}',
    );
    await webRtcController.close();
    await _initializeWebRtcSession(reason: 'reset');
    print(
      'WebRTC session reset complete: currentGeneration=$_webrtcSessionGeneration activeRequestId=$_activeRequestId remoteUri=$_remoteUri',
    );
  }

  Future<void> _initializeWebRtcSession({required String reason}) async {
    final nextGeneration = _webrtcSessionGeneration + 1;
    print(
      'Initializing WebRTC session generation=$nextGeneration reason=$reason dataChannels=${_configuredDataChannels.length} iceServers=${_configuredIceServers.length}',
    );
    await webRtcController.initialize(
      dataChannels: _configuredDataChannels,
      iceServers: _configuredIceServers,
    );
    _webrtcSessionGeneration = nextGeneration;
    print(
      'Initialized WebRTC session generation=$_webrtcSessionGeneration reason=$reason',
    );
  }

  bool _isHaveLocalOfferError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('have-local-offer') ||
        (message.contains('wrong state') && message.contains('local-offer'));
  }

  bool _shouldDropIncomingRequest({
    required String remoteUri,
    required String requestId,
  }) {
    return webRtcController.state.status == WebRtcStatus.connected &&
        _remoteUri == remoteUri &&
        _activeRequestId != null &&
        _activeRequestId != requestId;
  }

  bool _shouldDropOutgoingRequest({required String toUri}) {
    return webRtcController.state.status == WebRtcStatus.connected &&
        _remoteUri == toUri &&
        _activeRequestId != null;
  }
}
