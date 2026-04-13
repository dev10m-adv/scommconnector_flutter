import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

class RemoveDataChannelUseCase {
  final WebRtcSessionManager manager;

  const RemoveDataChannelUseCase(this.manager);

  Future<void> call({required String sessionId, required String label}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.removeDataChannel(label);
  }
}
