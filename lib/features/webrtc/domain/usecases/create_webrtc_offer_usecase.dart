import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

import '../entities/webrtc_session_description.dart';

class CreateWebRtcOfferUseCase {
  final WebRtcSessionManager manager;

  const CreateWebRtcOfferUseCase(this.manager);

  Future<WebRtcSessionDescription> call({required String sessionId, bool iceRestart = false}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.createOffer(iceRestart: iceRestart);
  }
}
