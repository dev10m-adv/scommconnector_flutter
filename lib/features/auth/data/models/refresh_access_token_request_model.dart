class RefreshAccessTokenRequestModel {
  final String refreshToken;

  const RefreshAccessTokenRequestModel({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}
