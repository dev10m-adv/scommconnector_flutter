import '../entities/webrtc_session_description.dart';
import '../repositories/webrtc_repository.dart';

class CreateWebRtcOfferUseCase {
  final WebRtcRepository repository;

  const CreateWebRtcOfferUseCase(this.repository);

  Future<WebRtcSessionDescription> call({bool iceRestart = false}) {
    return repository.createOffer(iceRestart: iceRestart);
  }
}
