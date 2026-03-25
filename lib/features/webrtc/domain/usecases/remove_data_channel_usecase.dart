import '../repositories/webrtc_repository.dart';

class RemoveDataChannelUseCase {
  final WebRtcRepository repository;

  const RemoveDataChannelUseCase(this.repository);

  Future<void> call(String label) {
    return repository.removeDataChannel(label);
  }
}
