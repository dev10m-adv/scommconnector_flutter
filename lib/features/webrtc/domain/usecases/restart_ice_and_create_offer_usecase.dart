import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

import '../entities/webrtc_session_description.dart';

class RestartIceAndCreateOfferUseCase {
  final WebRtcSessionManager manager;

  const RestartIceAndCreateOfferUseCase(this.manager);

  Future<WebRtcSessionDescription> call({required String sessionId}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.restartIceAndCreateOffer();
  }
}
