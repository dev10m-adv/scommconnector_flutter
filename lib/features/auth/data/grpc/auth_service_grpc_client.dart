import '../models/auth_tokens_model.dart';
import '../models/exchange_external_token_request_model.dart';
import '../models/exchange_imap_credentials_request_model.dart';
import '../models/refresh_access_token_request_model.dart';

abstract class AuthServiceGrpcClient {
  Future<AuthTokensModel> exchangeExternalToken(
    ExchangeExternalTokenRequestModel request,
  );

  Future<AuthTokensModel> exchangeImapCredentials(
    ExchangeImapCredentialsRequestModel request,
  );

  Future<AuthTokensModel> refreshTokens(RefreshAccessTokenRequestModel request);
}
