import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRtcPeerService fresh connection', () {
    test(
      'connects cleanly when peer B creates the offer',
      () => runFreshConnectionScenario(offerer: PeerSide.b),
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
