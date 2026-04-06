class WebRtcIceServerConfig {
  final List<String> urls;
  final String? username;
  final String? credential;

  const WebRtcIceServerConfig({
    required this.urls,
    this.username,
    this.credential,
  });

  Map<String, dynamic> toJson() {
    return {
      'urls': urls,
      if (username != null) 'username': username,
      if (credential != null) 'credential': credential,
    };
  }

  factory WebRtcIceServerConfig.fromJson(Map<String, dynamic> json) {
    return WebRtcIceServerConfig(
      urls: (json['urls'] as List<dynamic>).map((e) => e.toString()).toList(),
      username: json['username'] as String?,
      credential: json['credential'] as String?,
    );
  }
}
