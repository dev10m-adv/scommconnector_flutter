class ExchangeExternalTokenParams {
  final String provider;
  final String externalAccessToken;
  final String email;

  const ExchangeExternalTokenParams({
    required this.provider,
    required this.externalAccessToken,
    required this.email,
  });
}
