import '../entities/webrtc_ice_candidate.dart';
import '../repositories/webrtc_repository.dart';

class AddRemoteIceCandidateUseCase {
  final WebRtcRepository repository;

  const AddRemoteIceCandidateUseCase(this.repository);

  Future<void> call(WebRtcIceCandidate candidate) {
    return repository.addRemoteIceCandidate(candidate);
  }
}
