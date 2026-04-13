import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

class CloseWebRtcUseCase {
  final WebRtcSessionManager manager;

  const CloseWebRtcUseCase(this.manager);

  Future<void> call({required String sessionId}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.close();
  }
}
