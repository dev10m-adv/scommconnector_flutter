import '../repositories/webrtc_repository.dart';

class CloseWebRtcUseCase {
  final WebRtcRepository repository;

  const CloseWebRtcUseCase(this.repository);

  Future<void> call() {
    return repository.close();
  }
}
