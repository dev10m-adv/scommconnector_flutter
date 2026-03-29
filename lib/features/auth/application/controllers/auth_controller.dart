import 'package:scommconnector/core/di/service_locator.dart';

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

class ScommAuthController {
  AuthState _state = const AuthState();

  ScommAuthController();

  final ExchangeExternalTokenUseCase _exchangeExternalTokenUseCase =
      getIt<ExchangeExternalTokenUseCase>();
  final ExchangeImapCredentialsUseCase _exchangeImapCredentialsUseCase =
      getIt<ExchangeImapCredentialsUseCase>();
  final RefreshAccessTokenUseCase _refreshAccessTokenUseCase =
      getIt<RefreshAccessTokenUseCase>();
  final GetAccessTokenUseCase _getAccessTokenUseCase =
      getIt<GetAccessTokenUseCase>();

  AuthState get state => _state;

  Future<void> exchangeProviderToken({
    required String provider,
    required String externalAccessToken,
    required String userId,
  }) async {
    _setLoading();

    try {
      final tokens = await _exchangeExternalTokenUseCase(
        ExchangeExternalTokenParams(
          provider: provider,
          externalAccessToken: externalAccessToken,
          userId: userId,
        ),
      );
      _setAuthenticated(tokens);
      getIt<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }


  Future<void> initialize(String userId) async {
    try {
      final token = await getAccessToken(userId: userId);
      if (token == null || token.isEmpty) {
        _state = _state.copyWith(status: AuthStatus.failure, error: 'No stored access token found.');
        return;
      }
      _state = _state.copyWith(
        status: AuthStatus.authenticated,
        tokens: AuthTokens(accessToken: token, refreshToken: ''),
      );
      getIt<AuthSessionState>().setAccessToken(token);
    } on UnauthorizedException {
      _state = _state.copyWith(status: AuthStatus.failure, error: 'Stored token expired. Re-authentication required.');
    } catch (error) {
      _state = _state.copyWith(
        status: AuthStatus.failure,
        error: 'Unable to read stored token: $error',
      );
    }
  }

  Future<void> exchangeImapLogin({
    required ImapCredentials credentials,
  }) async {
    _setLoading();

    try {
      print('Exchanging IMAP credentials for tokens...');
      final tokens = await _exchangeImapCredentialsUseCase(
        ExchangeImapCredentialsParams(
          provider: 'imap',
          imapCredentials: credentials,
          userId: credentials.userId,
        ),
      );
      _setAuthenticated(tokens);
      getIt<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<void> refreshAccessToken({
    required String refreshToken,
    required String userId,
  }) async {
    _setLoading();

    try {
      final tokens = await _refreshAccessTokenUseCase(
        RefreshAccessTokenParams(refreshToken: refreshToken, userId: userId),
      );
      _setAuthenticated(tokens);
      getIt<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<String?> getAccessToken({required String userId}) {
    return _getAccessTokenUseCase(userId);
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

  bool isAuthenticatedSync() {
    return _state.status == AuthStatus.authenticated && _state.tokens != null;
  }

  Future<bool> isAuthenticated(String userId) async {
    try {
      final token = await getAccessToken(userId: userId);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
