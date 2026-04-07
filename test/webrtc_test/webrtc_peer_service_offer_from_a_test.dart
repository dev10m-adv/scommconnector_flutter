import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRtcPeerService fresh connection', () {
    test(
      'completes a clean offer answer exchange and opens one data channel',
      () => runFreshConnectionScenario(offerer: PeerSide.a),
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
