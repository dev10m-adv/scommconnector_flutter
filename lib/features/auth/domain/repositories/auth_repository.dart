import '../entities/auth_tokens.dart';
import '../entities/imap_credentials.dart';

abstract class AuthRepository {
  Future<AuthTokens> exchangeExternalProviderToken({
    required String provider,
    required String externalAccessToken,
    required String email,
  });

  Future<AuthTokens> exchangeImapCredentials({
    required String provider,
    required ImapCredentials imapCredentials,
    required String email,
  });

  Future<AuthTokens> refreshTokens({
    required String refreshToken,
    required String email,
  });

  Future<String?> getStoredAccessToken({
    required String email,
  });

  Future<void> clearTokens();

  Future<void> clearUserToken({
    required String email,
  });


  Future<String?> getLastUserEmail();
  Future<void> removeLastUserEmail();
}
