enum WebRtcIceCandidateType { host, srflx, prflx, relay, unknown }

enum WebRtcIceRouteType { host, srflx, relay, unknown }

class WebRtcIceRoute {
  const WebRtcIceRoute({
    this.routeType = WebRtcIceRouteType.unknown,
    this.localCandidateType = WebRtcIceCandidateType.unknown,
    this.remoteCandidateType = WebRtcIceCandidateType.unknown,
    this.localProtocol,
    this.remoteProtocol,
    this.candidatePairId,
  });

  final WebRtcIceRouteType routeType;
  final WebRtcIceCandidateType localCandidateType;
  final WebRtcIceCandidateType remoteCandidateType;
  final String? localProtocol;
  final String? remoteProtocol;
  final String? candidatePairId;

  bool get isKnown => routeType != WebRtcIceRouteType.unknown;

  Map<String, dynamic> toJson() {
    return {
      'routeType': routeType.name,
      'localCandidateType': localCandidateType.name,
      'remoteCandidateType': remoteCandidateType.name,
      'localProtocol': localProtocol,
      'remoteProtocol': remoteProtocol,
      'candidatePairId': candidatePairId,
    };
  }

  factory WebRtcIceRoute.fromJson(Map<String, dynamic> json) {
    return WebRtcIceRoute(
      routeType: WebRtcIceRouteType.values.firstWhere(
        (value) => value.name == json['routeType'],
        orElse: () => WebRtcIceRouteType.unknown,
      ),
      localCandidateType: WebRtcIceCandidateType.values.firstWhere(
        (value) => value.name == json['localCandidateType'],
        orElse: () => WebRtcIceCandidateType.unknown,
      ),
      remoteCandidateType: WebRtcIceCandidateType.values.firstWhere(
        (value) => value.name == json['remoteCandidateType'],
        orElse: () => WebRtcIceCandidateType.unknown,
      ),
      localProtocol: json['localProtocol'] as String?,
      remoteProtocol: json['remoteProtocol'] as String?,
      candidatePairId: json['candidatePairId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is WebRtcIceRoute &&
        other.routeType == routeType &&
        other.localCandidateType == localCandidateType &&
        other.remoteCandidateType == remoteCandidateType &&
        other.localProtocol == localProtocol &&
        other.remoteProtocol == remoteProtocol &&
        other.candidatePairId == candidatePairId;
  }

  @override
  int get hashCode => Object.hash(
    routeType,
    localCandidateType,
    remoteCandidateType,
    localProtocol,
    remoteProtocol,
    candidatePairId,
  );
}
