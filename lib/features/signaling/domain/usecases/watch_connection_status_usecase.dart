import '../entities/signaling_entities.dart';
import '../repositories/signaling_repository.dart';

class WatchConnectionStatusUseCase {
  final SignalingRepository repository;

  const WatchConnectionStatusUseCase(this.repository);

  Stream<SignalingConnectionStatus> call() {
    return repository.connectionStatus;
  }
}
