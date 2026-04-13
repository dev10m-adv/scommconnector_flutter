import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';
import '../entities/webrtc_session_description.dart';

class SetRemoteAnswerUseCase {
  final WebRtcSessionManager manager;

  const SetRemoteAnswerUseCase(this.manager);

  Future<void> call({required String sessionId, required WebRtcSessionDescription answer}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.setRemoteAnswer(answer);
  }
}
