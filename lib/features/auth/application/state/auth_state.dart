class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;
  final String? userId;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.error,
    this.userId,
  });

  const AuthState.initial()
      : isLoggedIn = false,
        isLoading = false,
        error = null,
        userId = null;

  const AuthState.loading()
      : isLoggedIn = false,
        isLoading = true,
        error = null,
        userId = null;

  const AuthState.authenticated(String this.userId)
      : isLoggedIn = true,
        isLoading = false,
        error = null;


  const AuthState.unauthenticated({this.error})
      : isLoggedIn = false,
        isLoading = false,
        userId = null;

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
    String? userId,

    bool clearError = false,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      error: clearError ? null : (error ?? this.error),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'isLoading': isLoading,
      'error': error,
      'userId': userId,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      isLoggedIn: json['isLoggedIn'] as bool,
      isLoading: json['isLoading'] as bool,
      error: json['error'] as String?,
      userId: json['userId'] as String?,
    );
  }
}