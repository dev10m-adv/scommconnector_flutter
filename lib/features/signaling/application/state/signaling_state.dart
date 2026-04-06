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

  factory SignalingState.initial() {
    return const SignalingState();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'message': message,
      'error': error,
    };
  }

  factory SignalingState.fromJson(Map<String, dynamic> json) {
    return SignalingState(
      status: SignalingStatus.values.firstWhere(
          (e) => e.toString() == json['status'],
          orElse: () => SignalingStatus.initial),
      message: json['message'],
      error: json['error'],
    );
  }
}
