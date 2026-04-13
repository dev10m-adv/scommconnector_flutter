import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

import '../entities/webrtc_session_description.dart';

class CreateWebRtcAnswerUseCase {
  final WebRtcSessionManager manager;

  const CreateWebRtcAnswerUseCase(this.manager);

  Future<WebRtcSessionDescription> call({required String sessionId, required WebRtcSessionDescription offer}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.createAnswerForOffer(offer);
  }
}
