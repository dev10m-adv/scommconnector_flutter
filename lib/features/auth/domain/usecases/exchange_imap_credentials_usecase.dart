import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';
import 'params/exchange_imap_credentials_params.dart';

class ExchangeImapCredentialsUseCase {
  final AuthRepository repository;

  const ExchangeImapCredentialsUseCase(this.repository);

  Future<AuthTokens> call(ExchangeImapCredentialsParams params) {
    return repository.exchangeImapCredentials(
      provider: params.provider,
      imapCredentials: params.imapCredentials,
      email: params.email,
    );
  }
}
