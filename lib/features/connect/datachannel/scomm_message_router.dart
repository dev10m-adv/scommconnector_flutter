import 'scomm_datachannel_protocol.dart';

typedef ScommMessageHandler = Future<void> Function(ScommRemoteMessage message);

class ScommMessageRouter {
  final Map<String, ScommMessageHandler> _handlers =
      <String, ScommMessageHandler>{};

  void register({
    required String service,
    required String action,
    required ScommMessageHandler handler,
  }) {
    _handlers[_key(service, action)] = handler;
  }

  Future<void> route(ScommRemoteMessage message) async {
    if (!message.isRoutable) return;

    final handler = _handlers[_key(message.service, message.action)];
    if (handler == null) return;
    await handler(message);
  }

  String _key(String service, String action) =>
      '${service.trim()}::${action.trim()}';
}
