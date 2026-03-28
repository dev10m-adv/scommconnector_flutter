import 'dart:convert';

enum ScommMessageType { request, response, stream, event }

extension ScommMessageTypeCodec on ScommMessageType {
  String get wireValue {
    switch (this) {
      case ScommMessageType.request:
        return 'REQUEST';
      case ScommMessageType.response:
        return 'RESPONSE';
      case ScommMessageType.stream:
        return 'STREAM';
      case ScommMessageType.event:
        return 'EVENT';
    }
  }

  static ScommMessageType fromWireValue(String raw) {
    switch (raw.trim().toUpperCase()) {
      case 'REQUEST':
        return ScommMessageType.request;
      case 'RESPONSE':
        return ScommMessageType.response;
      case 'STREAM':
        return ScommMessageType.stream;
      case 'EVENT':
        return ScommMessageType.event;
      default:
        throw FormatException('Unsupported message type: $raw');
    }
  }
}

class ScommRemoteMessage {
  final ScommMessageType type;
  final String service;
  final String action;
  final String? requestId;
  final Map<String, dynamic> data;

  const ScommRemoteMessage({
    required this.type,
    required this.service,
    required this.action,
    required this.data,
    this.requestId,
  });

  bool get requiresRequestId => type != ScommMessageType.event;

  bool get isRoutable =>
      type == ScommMessageType.request || type == ScommMessageType.event;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.wireValue,
      if (requestId != null && requestId!.trim().isNotEmpty)
        'requestId': requestId,
      'service': service,
      'action': action,
      'data': data,
    };
  }

  String encode() => jsonEncode(toJson());

  factory ScommRemoteMessage.fromJson(Map<String, dynamic> json) {
    final message = ScommRemoteMessage(
      type: ScommMessageTypeCodec.fromWireValue(json['type']?.toString() ?? ''),
      requestId: json['requestId']?.toString(),
      service: json['service']?.toString().trim() ?? '',
      action: json['action']?.toString().trim() ?? '',
      data: _asMap(json['data']) ?? const <String, dynamic>{},
    );

    if (message.service.isEmpty) {
      throw const FormatException('service is required');
    }
    if (message.action.isEmpty) {
      throw const FormatException('action is required');
    }
    if (message.requiresRequestId &&
        (message.requestId == null || message.requestId!.trim().isEmpty)) {
      throw const FormatException('requestId is required');
    }

    return message;
  }

  static ScommRemoteMessage? tryParse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return ScommRemoteMessage.fromJson(decoded);
      }
      if (decoded is Map) {
        return ScommRemoteMessage.fromJson(Map<String, dynamic>.from(decoded));
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
