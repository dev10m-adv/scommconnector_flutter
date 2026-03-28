class ExchangeExternalTokenParams {
  final String provider;
  final String externalAccessToken;
  final String userId;

  const ExchangeExternalTokenParams({
    required this.provider,
    required this.externalAccessToken,
    required this.userId,
  });
}
