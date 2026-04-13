import '../entities/signaling_entities.dart';

abstract class SignalingRepository {
    Stream<SignalingEnvelope> get messages;

  Stream<SignalingConnectionStatus> get connectionStatus;

  Future<void> connect({required String deviceId});

  Future<void> sendEnvelope(SignalingEnvelope envelope);

  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  });

  Future<void> disconnect();

  Future<void> dispose();
}
