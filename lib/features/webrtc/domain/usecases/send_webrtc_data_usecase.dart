import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

class SendWebRtcDataUseCase {
  final WebRtcSessionManager manager;

  const SendWebRtcDataUseCase(this.manager);

  Future<void> call({required String sessionId, required String channelLabel, required String message}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.sendData(channelLabel: channelLabel, message: message);
  }
}
