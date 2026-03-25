import '../entities/webrtc_session_description.dart';
import '../repositories/webrtc_repository.dart';

class SetRemoteAnswerUseCase {
  final WebRtcRepository repository;

  const SetRemoteAnswerUseCase(this.repository);

  Future<void> call(WebRtcSessionDescription answer) {
    return repository.setRemoteAnswer(answer);
  }
}
