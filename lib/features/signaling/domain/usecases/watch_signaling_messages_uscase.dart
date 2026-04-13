import '../entities/signaling_entities.dart';
import '../repositories/signaling_repository.dart';

class WatchSignalingMessagesUseCase {
  final SignalingRepository repository;

  const WatchSignalingMessagesUseCase(this.repository);

  Stream<SignalingEnvelope> call() {
    return repository.messages;
  }
}
