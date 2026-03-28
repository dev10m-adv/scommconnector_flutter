import '../entities/auth_tokens.dart';
import '../entities/imap_credentials.dart';

abstract class AuthRepository {
  Future<AuthTokens> exchangeExternalProviderToken({
    required String provider,
    required String externalAccessToken,
    required String userId,
  });

  Future<AuthTokens> exchangeImapCredentials({
    required String provider,
    required ImapCredentials imapCredentials,
    required String userId,
  });

  Future<AuthTokens> refreshTokens({
    required String refreshToken,
    required String userId,
  });

  Future<String?> getStoredAccessToken({
    required String userId,
  });

  Future<void> clearTokens();

  Future<void> clearUserToken({
    required String userId,
  });
}
