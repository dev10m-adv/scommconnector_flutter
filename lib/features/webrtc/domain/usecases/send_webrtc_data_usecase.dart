import '../repositories/webrtc_repository.dart';

class SendWebRtcDataUseCase {
  final WebRtcRepository repository;

  const SendWebRtcDataUseCase(this.repository);

  Future<void> call({required String channelLabel, required String message}) {
    return repository.sendData(channelLabel: channelLabel, message: message);
  }
}
