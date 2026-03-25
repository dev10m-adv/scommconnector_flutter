class WebRtcIceCandidate {
  final String candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;

  const WebRtcIceCandidate({
    required this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });
}
