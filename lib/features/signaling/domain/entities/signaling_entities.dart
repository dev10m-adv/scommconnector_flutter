enum SignalingPayloadType {
  unknown,
  hello,
  connectionRequest,
  connectionResponse,
  offer,
  answer,
  iceCandidate,
  ping,
  pong,
}

enum SignalingConnectionResponseStatus {
  unspecified,
  accepted,
  rejected,
  busy,
  blocked,
}

class SignalingDeviceRef {
  final String uri;

  const SignalingDeviceRef({required this.uri});
}

class SignalingConnectionRequest {
  final String requestId;
  final String serviceName;
  final String note;

  const SignalingConnectionRequest({
    required this.requestId,
    required this.serviceName,
    this.note = '',
  });
}

class SignalingConnectionResponse {
  final String requestId;
  final SignalingConnectionResponseStatus status;
  final String reason;

  const SignalingConnectionResponse({
    required this.requestId,
    required this.status,
    this.reason = '',
  });
}

class SignalingOffer {
  final String requestId;
  final String sdp;

  const SignalingOffer({required this.requestId, required this.sdp});
}

class SignalingAnswer {
  final String requestId;
  final String sdp;

  const SignalingAnswer({required this.requestId, required this.sdp});
}

class SignalingIceCandidate {
  final String requestId;
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;

  const SignalingIceCandidate({
    required this.requestId,
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });
}

class SignalingEnvelope {
  final String messageId;
  final String sessionId;
  final SignalingDeviceRef? from;
  final SignalingDeviceRef? to;

  final String? helloDeviceId;
  final SignalingConnectionRequest? connectionRequest;
  final SignalingConnectionResponse? connectionResponse;
  final SignalingOffer? offer;
  final SignalingAnswer? answer;
  final SignalingIceCandidate? iceCandidate;

  final int? pingTimestampMs;
  final int? pongTimestampMs;

  const SignalingEnvelope({
    required this.messageId,
    this.sessionId = '',
    this.from,
    this.to,
    this.helloDeviceId,
    this.connectionRequest,
    this.connectionResponse,
    this.offer,
    this.answer,
    this.iceCandidate,
    this.pingTimestampMs,
    this.pongTimestampMs,
  });

  SignalingPayloadType get payloadType {
    if (helloDeviceId != null && helloDeviceId!.isNotEmpty) {
      return SignalingPayloadType.hello;
    }
    if (connectionRequest != null)
      return SignalingPayloadType.connectionRequest;
    if (connectionResponse != null) {
      return SignalingPayloadType.connectionResponse;
    }
    if (offer != null) return SignalingPayloadType.offer;
    if (answer != null) return SignalingPayloadType.answer;
    if (iceCandidate != null) return SignalingPayloadType.iceCandidate;
    if (pingTimestampMs != null) return SignalingPayloadType.ping;
    if (pongTimestampMs != null) return SignalingPayloadType.pong;
    return SignalingPayloadType.unknown;
  }
}

class SignalingPresenceEvent {
  final String deviceUri;
  final String status;
  final int lastSeenAtMs;

  const SignalingPresenceEvent({
    required this.deviceUri,
    required this.status,
    required this.lastSeenAtMs,
  });
}

typedef SignalEnvelope = SignalingEnvelope;
typedef PresenceEvent = SignalingPresenceEvent;
typedef DeviceRef = SignalingDeviceRef;
typedef ConnectionRequest = SignalingConnectionRequest;
typedef ConnectionResponse = SignalingConnectionResponse;
typedef OfferPayload = SignalingOffer;
typedef AnswerPayload = SignalingAnswer;
typedef IceCandidatePayload = SignalingIceCandidate;
