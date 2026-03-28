class ImapCredentials {
  final String username;
  final String password;
  final String host;
  final int port;
  final bool useTls;


  final String userId;

  const ImapCredentials({
    required this.username,
    required this.password,
    required this.host,
    required this.port,
    this.useTls = true,

    required this.userId,
  });
}
