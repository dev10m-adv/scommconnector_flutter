import '../entities/signaling_entities.dart';
import '../repositories/signaling_repository.dart';

class SendSignalEnvelopeUseCase {
  final SignalingRepository repository;

  const SendSignalEnvelopeUseCase(this.repository);

  Future<void> call(SignalEnvelope envelope) {
    return repository.sendEnvelope(envelope);
  }
}
