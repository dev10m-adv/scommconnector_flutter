import 'dart:async';

import 'scomm_datachannel_protocol.dart';
import 'scomm_datachannel_transport.dart';
import 'scomm_message_router.dart';

class ScommDatachannelController {
  final ScommDataChannelTransport transport;
  final ScommMessageRouter? router;

  final _messagesController = StreamController<ScommRemoteMessage>.broadcast();

  ScommDatachannelController({required this.transport, this.router});

  Stream<ScommRemoteMessage> get messages => _messagesController.stream;

  Future<String> sendRequest({
    required String service,
    required String action,
    required Map<String, dynamic> data,
    String? requestId,
  }) async {
    final message = ScommRemoteMessage(
      type: ScommMessageType.request,
      requestId: _normalizeRequestId(requestId),
      service: service,
      action: action,
      data: data,
    );
    await transport.send(message);
    return message.requestId!;
  }

  Future<void> sendResponse({
    required String requestId,
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return transport.send(
      ScommRemoteMessage(
        type: ScommMessageType.response,
        requestId: requestId.trim(),
        service: service,
        action: action,
        data: data,
      ),
    );
  }

  Future<void> sendStream({
    required String requestId,
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return transport.send(
      ScommRemoteMessage(
        type: ScommMessageType.stream,
        requestId: requestId.trim(),
        service: service,
        action: action,
        data: data,
      ),
    );
  }

  Future<void> sendEvent({
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return transport.send(
      ScommRemoteMessage(
        type: ScommMessageType.event,
        service: service,
        action: action,
        data: data,
      ),
    );
  }

  Future<ScommRemoteMessage?> receiveRawMessage(String rawMessage) async {
    final message = transport.parse(rawMessage);
    if (message == null) return null;

    if (!_messagesController.isClosed) {
      _messagesController.add(message);
    }

    if (router != null) {
      await router!.route(message);
    }

    return message;
  }

  Future<void> dispose() async {
    await _messagesController.close();
  }

  String _normalizeRequestId(String? requestId) {
    final normalized = requestId?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
    return 'req-${DateTime.now().microsecondsSinceEpoch}';
  }
}
