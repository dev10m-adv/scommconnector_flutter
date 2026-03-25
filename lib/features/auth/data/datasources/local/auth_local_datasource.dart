import '../../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens);

  Future<AuthTokensModel?> loadTokens();

  Future<String?> getAccessToken();

  Future<void> clearTokens();
}
