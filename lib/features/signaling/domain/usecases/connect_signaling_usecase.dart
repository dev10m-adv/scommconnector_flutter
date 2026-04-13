import '../repositories/signaling_repository.dart';

class ConnectSignalingUseCase {
  final SignalingRepository repository;

  const ConnectSignalingUseCase(this.repository);

  Future<void> call({required String deviceId}) {
    return repository.connect(deviceId: deviceId);
  }
}
