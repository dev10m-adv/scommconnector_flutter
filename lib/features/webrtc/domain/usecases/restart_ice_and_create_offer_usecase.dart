import '../entities/webrtc_session_description.dart';
import '../repositories/webrtc_repository.dart';

class RestartIceAndCreateOfferUseCase {
  final WebRtcRepository repository;

  const RestartIceAndCreateOfferUseCase(this.repository);

  Future<WebRtcSessionDescription> call() {
    return repository.restartIceAndCreateOffer();
  }
}
