import 'dart:async';

import '../webrtc/domain/entities/webrtc_ice_candidate.dart';

class ConnectSession {
  final String sessionId;
  final String requestId;
  final String remoteUri;

  StreamSubscription<WebRtcIceCandidate>? localIceSubscription;

  ConnectSession({
    required this.sessionId,
    required this.requestId,
    required this.remoteUri,
    this.localIceSubscription,
  });

  Future<void> dispose() async {
    await localIceSubscription?.cancel();
    localIceSubscription = null;
  }
}