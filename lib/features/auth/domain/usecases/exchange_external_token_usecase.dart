import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';
import 'params/exchange_external_token_params.dart';

class ExchangeExternalTokenUseCase {
  final AuthRepository repository;

  const ExchangeExternalTokenUseCase(this.repository);

  Future<AuthTokens> call(ExchangeExternalTokenParams params) {
    return repository.exchangeExternalProviderToken(
      provider: params.provider,
      externalAccessToken: params.externalAccessToken,
    );
  }
}
