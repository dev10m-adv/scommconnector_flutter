import '../entities/signaling_entities.dart';
import '../repositories/signaling_repository.dart';

class ConnectSignalingUseCase {
  final SignalingRepository repository;

  const ConnectSignalingUseCase(this.repository);

  Stream<SignalEnvelope> call({required String deviceId}) {
    return repository.connect(deviceId: deviceId);
  }
}
