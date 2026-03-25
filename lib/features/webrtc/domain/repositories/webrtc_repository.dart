import '../entities/webrtc_connection_state.dart';
import '../entities/webrtc_data_message.dart';
import '../entities/webrtc_ice_candidate.dart';
import '../entities/webrtc_ice_server_config.dart';
import '../entities/webrtc_session_description.dart';

abstract class WebRtcRepository {
  Stream<WebRtcConnectionState> get connectionStates;
  Stream<WebRtcIceCandidate> get localIceCandidates;
  Stream<WebRtcDataMessage> get dataMessages;

  Future<void> initialize({
    required List<String> dataChannelLabels,
    List<WebRtcIceServerConfig>? iceServers,
  });

  Future<WebRtcSessionDescription> createOffer({bool iceRestart = false});

  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  );

  Future<void> setRemoteAnswer(WebRtcSessionDescription answer);

  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate);

  Future<void> addDataChannel(String label);

  Future<void> removeDataChannel(String label);

  Future<void> sendData({
    required String channelLabel,
    required String message,
  });

  Future<WebRtcSessionDescription> restartIceAndCreateOffer();

  Future<void> close();
}
