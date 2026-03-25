enum SignalingStatus {
  initial,
  connecting,
  connected,
  reconnecting,
  disconnected,
  failure,
}

class SignalingState {
  final SignalingStatus status;
  final String? message;
  final String? error;

  const SignalingState({
    this.status = SignalingStatus.initial,
    this.message,
    this.error,
  });

  SignalingState copyWith({
    SignalingStatus? status,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return SignalingState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
