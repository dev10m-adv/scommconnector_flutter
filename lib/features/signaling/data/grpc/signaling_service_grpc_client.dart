import '../../domain/entities/signaling_entities.dart';

typedef SignalingAccessTokenProvider = Future<String?> Function();

abstract class SignalingServiceGrpcClient {
  Stream<SignalingEnvelope> connect({required String deviceId});

  Future<void> sendEnvelope(SignalingEnvelope envelope);

  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  });

  Future<void> disconnect();
}
