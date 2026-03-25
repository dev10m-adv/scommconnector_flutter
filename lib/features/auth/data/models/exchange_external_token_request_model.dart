class ExchangeExternalTokenRequestModel {
  final String provider;
  final String externalAccessToken;

  const ExchangeExternalTokenRequestModel({
    required this.provider,
    required this.externalAccessToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'externalAccessToken': externalAccessToken,
    };
  }
}
