import '../../entities/imap_credentials.dart';

class ExchangeImapCredentialsParams {
  final String provider;
  final ImapCredentials imapCredentials;

  const ExchangeImapCredentialsParams({
    this.provider = 'imap',
    required this.imapCredentials,
  });
}
