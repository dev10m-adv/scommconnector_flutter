import '../../domain/repositories/signaling_repository.dart';
import '../../domain/entities/signaling_entities.dart';
import '../grpc/signaling_service_grpc_client.dart';

class SignalingRepositoryImpl implements SignalingRepository {
  final SignalingServiceGrpcClient grpcClient;

  const SignalingRepositoryImpl({required this.grpcClient});
  
  @override
  Future<void> connect({required String deviceId}) {
    return grpcClient.connect(deviceId: deviceId);
  }
  
  @override
  Stream<SignalingConnectionStatus> get connectionStatus => grpcClient.connectionStatus;
  
  @override
  Future<void> disconnect() {
    return grpcClient.disconnect();
  }
  
  @override
  Future<void> dispose() {
    return grpcClient.dispose();
  }
  
  @override
  // TODO: implement messages
  Stream<SignalingEnvelope> get messages => grpcClient.messages;
  
  @override
  Future<void> sendEnvelope(SignalingEnvelope envelope) {
    return grpcClient.sendEnvelope(envelope);
  }
  
  @override
  Stream<SignalingPresenceEvent> watchPresence({required List<String> targetUris}) {
    return grpcClient.watchPresence(targetUris: targetUris);
  }
  
}
