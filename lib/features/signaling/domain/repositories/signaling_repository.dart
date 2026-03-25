import '../entities/signaling_entities.dart';

abstract class SignalingRepository {
  Stream<SignalingEnvelope> connect({required String deviceId});

  Future<void> sendEnvelope(SignalEnvelope envelope);

  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  });

  Future<void> disconnect();
}
