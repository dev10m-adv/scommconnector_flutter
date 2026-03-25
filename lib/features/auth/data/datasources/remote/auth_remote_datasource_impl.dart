import '../../models/auth_tokens_model.dart';
import '../../models/exchange_external_token_request_model.dart';
import '../../models/exchange_imap_credentials_request_model.dart';
import '../../models/refresh_access_token_request_model.dart';
import '../../grpc/auth_service_grpc_client.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthServiceGrpcClient grpcClient;

  const AuthRemoteDataSourceImpl({
    required this.grpcClient,
  });

  @override
  Future<AuthTokensModel> exchangeExternalProviderToken(
    ExchangeExternalTokenRequestModel request,
  ) async {
    return grpcClient.exchangeExternalToken(request);
  }

  @override
  Future<AuthTokensModel> exchangeImapCredentials(
    ExchangeImapCredentialsRequestModel request,
  ) async {
    return grpcClient.exchangeImapCredentials(request);
  }

  @override
  Future<AuthTokensModel> refreshTokens(RefreshAccessTokenRequestModel request) async {
    return grpcClient.refreshTokens(request);
  }
}
