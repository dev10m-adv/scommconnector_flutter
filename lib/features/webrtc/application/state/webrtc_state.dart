enum WebRtcStatus {
  idle,
  initializing,
  negotiating,
  connected,
  retrying,
  failed,
  closed,
}

class WebRtcState {
  final WebRtcStatus status;
  final int retryCount;
  final String? message;
  final String? error;

  const WebRtcState({
    this.status = WebRtcStatus.idle,
    this.retryCount = 0,
    this.message,
    this.error,
  });

  WebRtcState copyWith({
    WebRtcStatus? status,
    int? retryCount,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return WebRtcState(
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
    );
  }

  factory WebRtcState.initial() {
    return const WebRtcState();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'retryCount': retryCount,
      'message': message,
      'error': error,
    };
  }

  factory WebRtcState.fromJson(Map<String, dynamic> json) {
    return WebRtcState(
      status: WebRtcStatus.values.firstWhere(
          (e) => e.toString() == json['status'],
          orElse: () => WebRtcStatus.idle),
      retryCount: json['retryCount'] ?? 0,
      message: json['message'],
      error: json['error'],
    );
  }
}
