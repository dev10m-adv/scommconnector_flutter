import '../../domain/entities/imap_credentials.dart';

class ImapCredentialsModel {
  final String username;
  final String password;
  final String host;
  final int port;
  final bool useTls;

  const ImapCredentialsModel({
    required this.username,
    required this.password,
    required this.host,
    required this.port,
    required this.useTls,
  });

  factory ImapCredentialsModel.fromEntity(ImapCredentials entity) {
    return ImapCredentialsModel(
      username: entity.username,
      password: entity.password,
      host: entity.host,
      port: entity.port,
      useTls: entity.useTls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'host': host,
      'port': port,
      'useTls': useTls,
    };
  }
}
