import '../repositories/signaling_repository.dart';

class DisconnectSignalingUseCase {
  final SignalingRepository repository;

  const DisconnectSignalingUseCase(this.repository);

  Future<void> call() {
    return repository.disconnect();
  }
}
