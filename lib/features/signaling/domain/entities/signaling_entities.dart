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

enum SignalingConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  stopped,
  authRequired,
  failed,
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
    if (connectionRequest != null) {
      return SignalingPayloadType.connectionRequest;
    }
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

  Map<String, dynamic> toJson() {
        return {
      'messageId': messageId,
      'sessionId': sessionId,
      'from': from == null ? null : {'uri': from!.uri},
      'to': to == null ? null : {'uri': to!.uri},
      'helloDeviceId': helloDeviceId,
      'connectionRequest': connectionRequest == null
          ? null
          : {
              'requestId': connectionRequest!.requestId,
              'serviceName': connectionRequest!.serviceName,
              'note': connectionRequest!.note,
            },
      'connectionResponse': connectionResponse == null
          ? null
          : {
              'requestId': connectionResponse!.requestId,
              'status': connectionResponse!.status.name,
              'reason': connectionResponse!.reason,
            },
      'offer': offer == null
          ? null
          : {
              'requestId': offer!.requestId,
              'sdp': offer!.sdp,
            },
      'answer': answer == null
          ? null
          : {
              'requestId': answer!.requestId,
              'sdp': answer!.sdp,
            },
      'iceCandidate': iceCandidate == null
          ? null
          : {
              'requestId': iceCandidate!.requestId,
              'candidate': iceCandidate!.candidate,
              'sdpMid': iceCandidate!.sdpMid,
              'sdpMLineIndex': iceCandidate!.sdpMLineIndex,
            },
      'pingTimestampMs': pingTimestampMs,
      'pongTimestampMs': pongTimestampMs,
    };
  }


  factory SignalingEnvelope.fromJson(Map<String, dynamic> json) {
    return SignalingEnvelope(
      messageId: json['messageId'] as String,
      sessionId: json['sessionId'] as String? ?? '',
      from: json['from'] != null
          ? SignalingDeviceRef(uri: (json['from'] as Map<String, dynamic>)['uri'] as String)
          : null,
      to: json['to'] != null
          ? SignalingDeviceRef(uri: (json['to'] as Map<String, dynamic>)['uri'] as String)
          : null,
      helloDeviceId: json['helloDeviceId'] as String?,
      connectionRequest: json['connectionRequest'] != null
          ? SignalingConnectionRequest(
              requestId: (json['connectionRequest'] as Map<String, dynamic>)['requestId'] as String,
              serviceName: (json['connectionRequest'] as Map<String, dynamic>)['serviceName'] as String,
              note: (json['connectionRequest'] as Map<String, dynamic>)['note'] as String? ?? '',
            )
          : null,
      connectionResponse: json['connectionResponse'] != null
          ? SignalingConnectionResponse(
              requestId: (json['connectionResponse'] as Map<String, dynamic>)['requestId'] as String,
              status: SignalingConnectionResponseStatus.values.firstWhere(
                (e) => e.name == (json['connectionResponse'] as Map<String, dynamic>)['status'],
                orElse: () => SignalingConnectionResponseStatus.unspecified,
              ),
              reason: (json['connectionResponse'] as Map<String, dynamic>)['reason'] as String? ?? '',
            )
          : null,
      offer: json['offer'] != null
          ? SignalingOffer(
              requestId: (json['offer'] as Map<String, dynamic>)['requestId'] as String,
              sdp: (json['offer'] as Map<String, dynamic>)['sdp'] as String,
            )
          : null,
      answer: json['answer'] != null
          ? SignalingAnswer(
              requestId: (json['answer'] as Map<String, dynamic>)['requestId'] as String,
              sdp: (json['answer'] as Map<String, dynamic>)['sdp'] as String,
            )
          : null,
      iceCandidate: json['iceCandidate'] != null
          ? SignalingIceCandidate(
              requestId: (json['iceCandidate'] as Map<String, dynamic>)['requestId'] as String,
              candidate: (json['iceCandidate'] as Map<String, dynamic>)['candidate'] as String,
              sdpMid: (json['iceCandidate'] as Map<String, dynamic>)['sdpMid'] as String,
              sdpMLineIndex: (json['iceCandidate'] as Map<String, dynamic>)['sdpMLineIndex'] as int,
            )
          : null,
      pingTimestampMs: json['pingTimestampMs'] as int?,
      pongTimestampMs: json['pongTimestampMs'] as int?,
    );
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

  Map<String, dynamic> toJson() {
    return {
      'deviceUri': deviceUri,
      'status': status,
      'lastSeenAtMs': lastSeenAtMs,
    };
  }

  factory SignalingPresenceEvent.fromJson(Map<String, dynamic> json) {
    return SignalingPresenceEvent(
      deviceUri: json['deviceUri'] as String,
      status: json['status'] as String,
      lastSeenAtMs: json['lastSeenAtMs'] as int,
    );
  }
}

typedef SignalEnvelope = SignalingEnvelope;
typedef PresenceEvent = SignalingPresenceEvent;
typedef DeviceRef = SignalingDeviceRef;
typedef ConnectionRequest = SignalingConnectionRequest;
typedef ConnectionResponse = SignalingConnectionResponse;
typedef OfferPayload = SignalingOffer;
typedef AnswerPayload = SignalingAnswer;
typedef IceCandidatePayload = SignalingIceCandidate;
