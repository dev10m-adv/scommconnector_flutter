class WebRtcIceServerConfig {
  final List<String> urls;
  final String? username;
  final String? credential;

  const WebRtcIceServerConfig({
    required this.urls,
    this.username,
    this.credential,
  });
}
