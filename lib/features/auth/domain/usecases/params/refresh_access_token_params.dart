class RefreshAccessTokenParams {
  final String refreshToken;
  final String userId;

  const RefreshAccessTokenParams({
    required this.refreshToken,
    required this.userId,
  });
}
