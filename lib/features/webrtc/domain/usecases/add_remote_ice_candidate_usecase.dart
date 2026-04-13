import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';
import '../entities/webrtc_ice_candidate.dart';

class AddRemoteIceCandidateUseCase {
  final WebRtcSessionManager manager;

  const AddRemoteIceCandidateUseCase(this.manager);

  Future<void> call({required String sessionId, required WebRtcIceCandidate candidate}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.addRemoteIceCandidate(candidate);
  }
}
