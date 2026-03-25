import '../entities/auth_tokens.dart';
import '../entities/imap_credentials.dart';

abstract class AuthRepository {
  Future<AuthTokens> exchangeExternalProviderToken({
    required String provider,
    required String externalAccessToken,
  });

  Future<AuthTokens> exchangeImapCredentials({
    required String provider,
    required ImapCredentials imapCredentials,
  });

  Future<AuthTokens> refreshTokens({
    required String refreshToken,
  });

  Future<String?> getStoredAccessToken();

  Future<void> clearTokens();
}
