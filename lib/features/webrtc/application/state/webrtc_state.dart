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
}
