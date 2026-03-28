import 'scomm_datachannel_protocol.dart';

class ScommDataChannelTransport {
  static const String mainChannel = 'main';

  final Future<void> Function({
    required String channelLabel,
    required String message,
  })
  sendRawMessage;
  final bool Function() isConnected;

  const ScommDataChannelTransport({
    required this.sendRawMessage,
    required this.isConnected,
  });

  Future<void> send(ScommRemoteMessage message) async {
    if (!isConnected()) {
      throw StateError('Main data channel is not connected');
    }

    await sendRawMessage(channelLabel: mainChannel, message: message.encode());
  }

  ScommRemoteMessage? parse(String rawMessage) {
    return ScommRemoteMessage.tryParse(rawMessage);
  }
}
