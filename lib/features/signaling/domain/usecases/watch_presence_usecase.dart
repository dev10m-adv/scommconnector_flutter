import '../entities/signaling_entities.dart';
import '../repositories/signaling_repository.dart';

class WatchPresenceUseCase {
  final SignalingRepository repository;

  const WatchPresenceUseCase(this.repository);

  Stream<SignalingPresenceEvent> call({required List<String> targetUris}) {
    return repository.watchPresence(targetUris: targetUris);
  }
}
