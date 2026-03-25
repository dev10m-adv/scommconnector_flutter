import '../../../../core/errors/errors.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/imap_credentials.dart';
import '../../domain/usecases/exchange_external_token_usecase.dart';
import '../../domain/usecases/exchange_imap_credentials_usecase.dart';
import '../../domain/usecases/get_access_token_usecase.dart';
import '../../domain/usecases/params/exchange_external_token_params.dart';
import '../../domain/usecases/params/exchange_imap_credentials_params.dart';
import '../../domain/usecases/params/refresh_access_token_params.dart';
import '../../domain/usecases/refresh_access_token_usecase.dart';
import '../state/auth_state.dart';

class AuthController {
  final ExchangeExternalTokenUseCase exchangeExternalTokenUseCase;
  final ExchangeImapCredentialsUseCase exchangeImapCredentialsUseCase;
  final RefreshAccessTokenUseCase refreshAccessTokenUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;

  AuthState _state = const AuthState();

  AuthController({
    required this.exchangeExternalTokenUseCase,
    required this.exchangeImapCredentialsUseCase,
    required this.refreshAccessTokenUseCase,
    required this.getAccessTokenUseCase,
  });

  AuthState get state => _state;

  Future<AuthTokens> exchangeProviderToken({
    required String provider,
    required String externalAccessToken,
  }) async {
    _setLoading();

    try {
      final tokens = await exchangeExternalTokenUseCase(
        ExchangeExternalTokenParams(
          provider: provider,
          externalAccessToken: externalAccessToken,
        ),
      );
      _setAuthenticated(tokens);
      return tokens;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<AuthTokens> exchangeImapLogin({required ImapCredentials credentials}) async {
    _setLoading();

    try {
      final tokens = await exchangeImapCredentialsUseCase(
        ExchangeImapCredentialsParams(
          provider: 'imap',
          imapCredentials: credentials,
        ),
      );
      _setAuthenticated(tokens);
      return tokens;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<AuthTokens> refreshAccessToken({required String refreshToken}) async {
    _setLoading();

    try {
      final tokens = await refreshAccessTokenUseCase(
        RefreshAccessTokenParams(
          refreshToken: refreshToken,
        ),
      );
      _setAuthenticated(tokens);
      return tokens;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<String?> getAccessToken() {
    return getAccessTokenUseCase();
  }

  void _setLoading() {
    _state = _state.copyWith(status: AuthStatus.loading, clearError: true);
  }

  void _setAuthenticated(AuthTokens tokens) {
    _state = _state.copyWith(
      status: AuthStatus.authenticated,
      tokens: tokens,
      clearError: true,
    );
  }

  void _setFailure(Object error) {
    _state = _state.copyWith(
      status: AuthStatus.failure,
      error: _toUserMessage(error),
    );
  }

  String _toUserMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Authentication request failed. Please try again.';
  }
}
