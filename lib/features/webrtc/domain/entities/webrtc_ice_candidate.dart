class WebRtcIceCandidate {
  final String candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;

  const WebRtcIceCandidate({
    required this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });

  factory WebRtcIceCandidate.fromJson(Map<String, dynamic> json) {
    return WebRtcIceCandidate(
      candidate: json['candidate'] as String,
      sdpMid: json['sdpMid'] as String?,
      sdpMLineIndex: json['sdpMLineIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate,
      if (sdpMid != null) 'sdpMid': sdpMid,
      if (sdpMLineIndex != null) 'sdpMLineIndex': sdpMLineIndex,
    };
  }
}
