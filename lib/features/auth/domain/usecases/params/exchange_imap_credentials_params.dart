import '../../entities/imap_credentials.dart';

class ExchangeImapCredentialsParams {
  final String provider;
  final ImapCredentials imapCredentials;
  final String email;

  const ExchangeImapCredentialsParams({
    this.provider = 'imap',
    required this.imapCredentials,
    required this.email,
  });
}
