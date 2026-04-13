class RefreshAccessTokenParams {
  final String refreshToken;
  final String email;

  const RefreshAccessTokenParams({
    required this.refreshToken,
    required this.email,
  });
}
