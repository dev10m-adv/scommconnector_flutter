import '../../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens, String userId);

  Future<AuthTokensModel?> loadTokens(String userId);

  Future<String?> getAccessToken(String userId);

  Future<void> clearTokens();
  
  Future<void> clearUserToken(String userId);
}
