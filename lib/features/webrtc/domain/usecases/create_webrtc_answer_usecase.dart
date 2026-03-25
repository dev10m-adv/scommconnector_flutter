import '../entities/webrtc_session_description.dart';
import '../repositories/webrtc_repository.dart';

class CreateWebRtcAnswerUseCase {
  final WebRtcRepository repository;

  const CreateWebRtcAnswerUseCase(this.repository);

  Future<WebRtcSessionDescription> call(WebRtcSessionDescription offer) {
    return repository.createAnswerForOffer(offer);
  }
}
