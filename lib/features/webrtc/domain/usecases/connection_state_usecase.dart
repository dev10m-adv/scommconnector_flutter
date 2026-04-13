import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_connection_state.dart';

class ConnectionStateUseCase {
  final WebRtcSessionManager manager;
  const ConnectionStateUseCase(this.manager);
  Stream<WebRtcConnectionState> call({required String sessionId}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.connectionStates;
  }
}
