class WebRtcDataMessage {
  final String channelLabel;
  final String message;

  const WebRtcDataMessage({required this.channelLabel, required this.message});

  Map<String, dynamic> toJson() {
    return {
      'channelLabel': channelLabel,
      'message': message,
    };
  }

  factory WebRtcDataMessage.fromJson(Map<String, dynamic> json) {
    return WebRtcDataMessage(
      channelLabel: json['channelLabel'] as String,
      message: json['message'] as String,
    );  
  }
}
