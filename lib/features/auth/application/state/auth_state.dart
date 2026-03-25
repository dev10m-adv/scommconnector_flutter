import '../../domain/entities/auth_tokens.dart';

enum AuthStatus { initial, loading, authenticated, failure }

class AuthState {
  final AuthStatus status;
  final AuthTokens? tokens;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.tokens,
    this.error,
  });

  String? get accessToken => tokens?.accessToken;

  String? get refreshToken => tokens?.refreshToken;

  AuthState copyWith({
    AuthStatus? status,
    AuthTokens? tokens,
    String? error,
    bool clearTokens = false,
    bool clearDeviceRegistration = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      tokens: clearTokens ? null : (tokens ?? this.tokens),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
