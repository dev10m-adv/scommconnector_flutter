import 'dart:async';

import 'package:scommconnector/core/di/service_locator.dart';
import 'package:scommconnector/features/auth/domain/usecases/remove_last_user_usecase.dart';

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
import '../../domain/usecases/get_last_userId_usecase.dart';
import '../state/auth_state.dart';

class ScommAuthController {
  static final ScommAuthController _instance = ScommAuthController._internal();

  AuthState _state = AuthState.initial();

  factory ScommAuthController() => _instance;

  ScommAuthController._internal();

  final ExchangeExternalTokenUseCase _exchangeExternalTokenUseCase =
      scommDi<ExchangeExternalTokenUseCase>();
  final ExchangeImapCredentialsUseCase _exchangeImapCredentialsUseCase =
      scommDi<ExchangeImapCredentialsUseCase>();
  final RefreshAccessTokenUseCase _refreshAccessTokenUseCase =
      scommDi<RefreshAccessTokenUseCase>();
  final GetAccessTokenUseCase _getAccessTokenUseCase =
      scommDi<GetAccessTokenUseCase>();
  final GetLastUsedUserIdUseCase _getLastUsedUserIdUseCase =
      scommDi<GetLastUsedUserIdUseCase>();

  final RemoveLastUserUsecase _removeLastUserUsecase =
      scommDi<RemoveLastUserUsecase>();

  final _authStateStream = StreamController<AuthState>.broadcast();
  Stream<AuthState> get authStates => _authStateStream.stream;

  void _notify(AuthState newState) {
    _state = newState;
    _authStateStream.add(_state);
  }

  AuthState get state => _state;

  Future<void> exchangeProviderToken({
    required String provider,
    required String externalAccessToken,
    required String email,
  }) async {
    _setLoading();

    try {

      final tokens = await _exchangeExternalTokenUseCase(
        ExchangeExternalTokenParams(
          provider: provider,
          externalAccessToken: externalAccessToken,
          email: email,
        ),
      );
      _setAuthenticated(tokens, email);
      scommDi<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      // rethrow;
    }
  }

  Future<void> logout() async {
    _notify(_state.copyWith(isLoading: false, isLoggedIn: false, error: null));
    scommDi<AuthSessionState>().setAccessToken('');
    await _removeLastUserUsecase.call();
  }

  Future<void> init() async {
    print('Initializing authentication state...');
    // await _removeLastUserUsecase.call();
    final userId = await _getLastUsedUserIdUseCase.call();
    print('Last used userId: $userId');
    if (userId == null) {
      _notify(_state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        error: null,
        clearError: true
      ));
      return;
    }
    final token = await _getAccessToken(email: userId);
    print('Retrieved stored access token: $token');
    if (token == null || token.isEmpty) {
      _notify(_state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        error: 'No stored access token found. Please log in.',
      ));
      return;
    }
    _notify(_state.copyWith(
      isLoading: false,
      isLoggedIn: true,
      error: null,
      email: userId
    ));
    scommDi<AuthSessionState>().setAccessToken(token);
  }

  Future<void> initialize(String email) async {
    try {
      final token = await _getAccessToken(email: email);
      print('Retrieved stored access token for $email: $token');
      if (token == null || token.isEmpty) {
        _notify(_state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          error: 'No stored access token found. Please log in.',
        ));
        return;
      }
      _notify(_state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        error: null,
        email: _state.email,
      ));
      scommDi<AuthSessionState>().setAccessToken(token);
    } on UnauthorizedException {
      _notify(_state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        error: 'Stored token expired. Re-authentication required.',
      ));
    } catch (error) {
      _notify(_state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        error: 'Failed to initialize authentication: ${error.toString()}',
      ));
    }
  }

  Future<void> exchangeImapLogin({required ImapCredentials credentials}) async {
    _setLoading();
    try {
      print('Exchanging IMAP credentials for tokens...');
      final tokens = await _exchangeImapCredentialsUseCase(
        ExchangeImapCredentialsParams(
          provider: 'imap',
          imapCredentials: credentials,
          email: credentials.username,
        ),
      );
      _setAuthenticated(tokens, credentials.username);
      scommDi<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<void> refreshAccessToken({
    required String refreshToken,
    required String email,
  }) async {
    _setLoading();

    try {
      final tokens = await _refreshAccessTokenUseCase(
        RefreshAccessTokenParams(refreshToken: refreshToken, email: email),
      );
      _setAuthenticated(tokens, email);
      scommDi<AuthSessionState>().setAccessToken(tokens.accessToken);
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<String?> _getAccessToken({required String email}) {
    return _getAccessTokenUseCase(email);
  }

  void _setLoading() {
    _notify(_state.copyWith(clearError: true, isLoading: true, error: null));
  }

  void _setAuthenticated(AuthTokens tokens, String? email) {
    _notify(_state.copyWith(clearError: true, isLoading: false, isLoggedIn: true, error: null, email: email));
  }

  void _setFailure(Object error) {
    _notify(_state.copyWith(clearError: false, isLoading: false, isLoggedIn: false, error: _toUserMessage(error)));
  }

  String _toUserMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Authentication request failed. Please try again.';
  }
}
