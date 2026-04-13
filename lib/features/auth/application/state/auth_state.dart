class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;
  final String? email;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.error,
    this.email,
  });

  const AuthState.initial()
      : isLoggedIn = false,
        isLoading = false,
        error = null,
        email = null;

  const AuthState.loading()
      : isLoggedIn = false,
        isLoading = true,
        error = null,
        email = null;

  const AuthState.authenticated(String this.email)
      : isLoggedIn = true,
        isLoading = false,
        error = null;


  const AuthState.unauthenticated({this.error})
      : isLoggedIn = false,
        isLoading = false,
        email = null;

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
    String? email,

    bool clearError = false,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      error: clearError ? null : (error ?? this.error),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'isLoading': isLoading,
      'error': error,
      'email': email,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      isLoggedIn: json['isLoggedIn'] as bool,
      isLoading: json['isLoading'] as bool,
      error: json['error'] as String?,
      email: json['email'] as String?,
    );
  }
}