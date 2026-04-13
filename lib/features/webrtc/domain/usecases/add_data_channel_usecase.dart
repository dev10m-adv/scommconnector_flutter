import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

class AddDataChannelUseCase {
  final WebRtcSessionManager  manager;

  const AddDataChannelUseCase(this.manager);

  Future<void> call({required String sessionId, required String label}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.addDataChannel(label);
  }
}
