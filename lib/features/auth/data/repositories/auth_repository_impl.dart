import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/imap_credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/errors.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/exchange_external_token_request_model.dart';
import '../models/exchange_imap_credentials_request_model.dart';
import '../models/refresh_access_token_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const _refreshLeewaySeconds = 30;
  static const _reauthMessage =
      'Session expired. Please provide external token to perform authentication.';

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthTokens> exchangeExternalProviderToken({
    required String provider,
    required String externalAccessToken,
  }) async {
    final response = await remoteDataSource.exchangeExternalProviderToken(
      ExchangeExternalTokenRequestModel(
        provider: provider,
        externalAccessToken: externalAccessToken,
      ),
    );

    await localDataSource.saveTokens(response);
    return response.toEntity();
  }

  @override
  Future<AuthTokens> exchangeImapCredentials({
    required String provider,
    required ImapCredentials imapCredentials,
  }) async {
    final response = await remoteDataSource.exchangeImapCredentials(
      ExchangeImapCredentialsRequestModel(
        provider: provider,
        imapCredentials: imapCredentials,
      ),
    );

    await localDataSource.saveTokens(response);
    return response.toEntity();
  }

  @override
  Future<AuthTokens> refreshTokens({
    required String refreshToken,
  }) async {
    final response = await remoteDataSource.refreshTokens(
      RefreshAccessTokenRequestModel(
        refreshToken: refreshToken,
      ),
    );

    await localDataSource.saveTokens(response);
    return response.toEntity();
  }

  @override
  Future<String?> getStoredAccessToken() async {
    final storedTokens = await localDataSource.loadTokens();
    if (storedTokens == null || storedTokens.accessToken.isEmpty) {
      return null;
    }

    if (!_isAccessTokenExpired(storedTokens.expiresAt)) {
      return storedTokens.accessToken;
    }

    if (storedTokens.refreshToken.isEmpty) {
      await localDataSource.clearTokens();
      throw const UnauthorizedException(message: _reauthMessage);
    }

    try {
      final refreshedTokens = await remoteDataSource.refreshTokens(
        RefreshAccessTokenRequestModel(refreshToken: storedTokens.refreshToken),
      );

      await localDataSource.saveTokens(refreshedTokens);
      return refreshedTokens.accessToken;
    } on UnauthorizedException {
      await localDataSource.clearTokens();
      throw const UnauthorizedException(message: _reauthMessage);
    }
  }

  bool _isAccessTokenExpired(DateTime? expiresAt) {
    if (expiresAt == null) {
      return false;
    }

    final nowUtc = DateTime.now().toUtc();
    final effectiveExpiry = expiresAt.toUtc().subtract(
      const Duration(seconds: _refreshLeewaySeconds),
    );
    return !effectiveExpiry.isAfter(nowUtc);
  }

  @override
  Future<void> clearTokens() async {
    await localDataSource.clearTokens();
  }
}
