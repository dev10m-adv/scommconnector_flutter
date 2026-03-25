import '../../domain/entities/imap_credentials.dart';
import 'imap_credentials_model.dart';

class ExchangeImapCredentialsRequestModel {
  final String provider;
  final ImapCredentials imapCredentials;

  const ExchangeImapCredentialsRequestModel({
    this.provider = 'imap',
    required this.imapCredentials,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'imapCredentials': ImapCredentialsModel.fromEntity(imapCredentials).toJson(),
    };
  }
}
