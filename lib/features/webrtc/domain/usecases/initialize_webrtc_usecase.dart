import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

import '../entities/webrtc_ice_server_config.dart';

class InitializeWebRtcUseCase {
  final WebRtcSessionManager manager;

  const InitializeWebRtcUseCase(this.manager);

  Future<void> call({
    required String sessionId,
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  }) {
    final repository = manager.getOrCreate(sessionId);
    return repository.initialize(
      dataChannelLabels: dataChannelLabels,
      iceServers: iceServers,
    );
  }
}
