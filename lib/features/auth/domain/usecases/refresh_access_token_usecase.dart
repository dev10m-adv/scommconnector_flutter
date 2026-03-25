import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';
import 'params/refresh_access_token_params.dart';

class RefreshAccessTokenUseCase {
  final AuthRepository repository;

  const RefreshAccessTokenUseCase(this.repository);

  Future<AuthTokens> call(RefreshAccessTokenParams params) {
    return repository.refreshTokens(
      refreshToken: params.refreshToken,
    );
  }
}
