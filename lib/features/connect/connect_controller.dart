import 'dart:async';

import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';

import '../signaling/application/controllers/signaling_controller.dart';
import '../signaling/domain/entities/signaling_entities.dart';
import '../webrtc/application/controllers/webrtc_controller.dart';
import '../webrtc/domain/entities/webrtc_ice_candidate.dart';
import '../webrtc/domain/entities/webrtc_session_description.dart';

class ConnectController {
  final SignalingController signalingController;
  final WebRtcController webRtcController;

  StreamSubscription<SignalEnvelope>? _signalingSubscription;
  StreamSubscription<WebRtcIceCandidate>? _localIceSubscription;

  final _incomingConnectionRequests =
      StreamController<SignalEnvelope>.broadcast();

  String? _localUri;
  String? _remoteUri;
  String? _activeRequestId;

  ConnectController({
    required this.signalingController,
    required this.webRtcController,
  });

  Stream<SignalEnvelope> get incomingConnectionRequests =>
      _incomingConnectionRequests.stream;

  Future<void> start({
    required String deviceId,
    required String localUri,
    required List<String> dataChannels,
    List<WebRtcIceServerConfig> iceServers = const [],
  }) async {
    _localUri = localUri;

    try {
      await signalingController.start(deviceId: deviceId);

      // Attach incoming signaling listener immediately so early envelopes
      // (like connection requests) are not dropped while WebRTC initializes.
      await _signalingSubscription?.cancel();
      _signalingSubscription = signalingController.incomingMessages.listen(
        (envelope) => _handleSignalingEnvelopeSafe(envelope),
        onError: (error, stackTrace) {
          // Log error but don't crash the stream
          print('Error handling signaling envelope: $error');
        },
      );

      await webRtcController.initialize(
        dataChannels: dataChannels,
        iceServers: iceServers,
      );

      await _localIceSubscription?.cancel();
      _localIceSubscription = webRtcController.localIceCandidates.listen(
        _forwardLocalIceCandidate,
        onError: (error, stackTrace) {
          print('Error forwarding ICE candidate: $error');
        },
      );
    } catch (error) {
      // Rollback: if WebRTC init fails after signaling started, stop signaling
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
  }

  Future<void> initiateConnection({
    required String toUri,
    required String serviceName,
    String note = '',
    Duration timeout = const Duration(seconds: 12),
  }) async {
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

  Future<void> _handleSignalingEnvelopeSafe(SignalEnvelope envelope) async {
    try {
      await _handleSignalingEnvelope(envelope);
    } catch (error, stackTrace) {
      // Log error so it's not silently lost
      print('Error in _handleSignalingEnvelope: $error\n$stackTrace');
      // Re-throw so caller knows there was an issue
      rethrow;
    }
  }

  Future<void> _handleSignalingEnvelope(SignalEnvelope envelope) async {
    switch (envelope.payloadType) {
      case SignalingPayloadType.connectionRequest:
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

        _remoteUri = envelope.from?.uri;
        _activeRequestId = remoteOffer.requestId;

        if (_remoteUri == null || _activeRequestId == null) {
          break;
        }

        final answer = await webRtcController.createAnswerForOffer(offer);
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
}
