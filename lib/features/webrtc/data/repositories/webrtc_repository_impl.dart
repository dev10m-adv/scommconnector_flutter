import '../../domain/entities/webrtc_connection_state.dart';
import '../../domain/entities/webrtc_data_message.dart';
import '../../domain/entities/webrtc_ice_candidate.dart';
import '../../domain/entities/webrtc_ice_route.dart';
import '../../domain/entities/webrtc_ice_server_config.dart';
import '../../domain/entities/webrtc_session_description.dart';
import '../../domain/repositories/webrtc_repository.dart';
import '../services/webrtc_peer_service.dart';

class WebRtcRepositoryImpl implements WebRtcRepository {
  final WebRtcPeerService peerService;

  const WebRtcRepositoryImpl({required this.peerService});

  @override
  Stream<WebRtcConnectionState> get connectionStates =>
      peerService.connectionStates;

  @override
  Stream<WebRtcIceCandidate> get localIceCandidates =>
      peerService.localIceCandidates;

  @override
  Stream<WebRtcIceRoute> get iceRoutes => peerService.iceRoutes;

  @override
  Stream<WebRtcDataMessage> get dataMessages => peerService.dataMessages;

  @override
  WebRtcIceRoute get iceRoute => peerService.iceRoute;

  @override
  Future<void> initialize({
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  }) {
    return peerService.initialize(
      dataChannelLabels: dataChannelLabels,
      iceServers: iceServers,
    );
  }

  @override
  Future<WebRtcSessionDescription> createOffer({bool iceRestart = false}) {
    return peerService.createOffer(iceRestart: iceRestart);
  }

  @override
  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  ) {
    return peerService.createAnswerForOffer(offer);
  }

  @override
  Future<void> setRemoteAnswer(WebRtcSessionDescription answer) {
    return peerService.setRemoteAnswer(answer);
  }

  @override
  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) {
    return peerService.addRemoteIceCandidate(candidate);
  }

  @override
  Future<void> addDataChannel(String label) {
    return peerService.addDataChannel(label);
  }

  @override
  Future<void> removeDataChannel(String label) {
    return peerService.removeDataChannel(label);
  }

  @override
  Future<void> sendData({
    required String channelLabel,
    required String message,
  }) {
    return peerService.sendData(channelLabel: channelLabel, message: message);
  }

  @override
  Future<WebRtcIceRoute> refreshIceRoute() {
    return peerService.refreshIceRoute();
  }

  @override
  Future<WebRtcSessionDescription> restartIceAndCreateOffer() {
    return peerService.restartIceAndCreateOffer();
  }

  @override
  Future<void> close() {
    return peerService.close();
  }
}
