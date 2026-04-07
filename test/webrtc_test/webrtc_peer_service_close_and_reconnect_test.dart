import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRtcPeerService data channel correctness', () {
    test(
      'closes the old channel and reconnects without stale listeners',
      runCloseAndReconnectScenario,
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
