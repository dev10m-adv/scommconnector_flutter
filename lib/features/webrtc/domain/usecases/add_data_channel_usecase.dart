import '../repositories/webrtc_repository.dart';

class AddDataChannelUseCase {
  final WebRtcRepository repository;

  const AddDataChannelUseCase(this.repository);

  Future<void> call(String label) {
    return repository.addDataChannel(label);
  }
}
