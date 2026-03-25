import '../../domain/repositories/signaling_repository.dart';
import '../../domain/entities/signaling_entities.dart';
import '../grpc/signaling_service_grpc_client.dart';

class SignalingRepositoryImpl implements SignalingRepository {
  final SignalingServiceGrpcClient grpcClient;

  const SignalingRepositoryImpl({required this.grpcClient});

  @override
  Stream<SignalEnvelope> connect({required String deviceId}) {
    return grpcClient.connect(deviceId: deviceId);
  }

  @override
  Future<void> sendEnvelope(SignalEnvelope envelope) {
    return grpcClient.sendEnvelope(envelope);
  }

  @override
  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  }) {
    return grpcClient.watchPresence(targetUris: targetUris);
  }

  @override
  Future<void> disconnect() {
    return grpcClient.disconnect();
  }
}
