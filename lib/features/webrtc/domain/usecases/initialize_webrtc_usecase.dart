import '../entities/webrtc_ice_server_config.dart';
import '../repositories/webrtc_repository.dart';

class InitializeWebRtcUseCase {
  final WebRtcRepository repository;

  const InitializeWebRtcUseCase(this.repository);

  Future<void> call({
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  }) {
    return repository.initialize(
      dataChannelLabels: dataChannelLabels,
      iceServers: iceServers,
    );
  }
}
