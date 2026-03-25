import 'dart:async';
import 'dart:math';

import '../entities/signaling_entities.dart';

/// Callback to send a heartbeat/ping message.
typedef SendHeartbeatCallback =
    Future<void> Function(SignalingEnvelope envelope);

/// Maintains connection health by sending periodic heartbeats.
///
/// Single Responsibility: Manage heartbeat scheduling and payload generation.
abstract class IConnectionHealthMonitor {
  /// Start sending heartbeats at [interval].
  void startHeartbeat({
    required Duration interval,
    required SendHeartbeatCallback onSendHeartbeat,
  });

  /// Stop sending heartbeats.
  Future<void> stopHeartbeat();

  /// Check if heartbeat is currently active.
  bool get isActive;
}

/// Default implementation using Timer.periodic.
class ConnectionHealthMonitor implements IConnectionHealthMonitor {
  Timer? _heartbeatTimer;
  bool _isActive = false;

  @override
  bool get isActive => _isActive;

  @override
  void startHeartbeat({
    required Duration interval,
    required SendHeartbeatCallback onSendHeartbeat,
  }) {
    stopHeartbeat(); // Ensure previous timer is cancelled
    _isActive = true;

    _heartbeatTimer = Timer.periodic(interval, (_) {
      final envelope = _buildPingEnvelope();
      onSendHeartbeat(envelope);
    });
  }

  @override
  Future<void> stopHeartbeat() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _isActive = false;
  }

  SignalingEnvelope _buildPingEnvelope() {
    return SignalingEnvelope(
      messageId: _buildMessageId(),
      pingTimestampMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _buildMessageId() {
    final millis = DateTime.now().microsecondsSinceEpoch;
    final rand = Random().nextInt(1 << 20);
    return '$millis-$rand';
  }
}
