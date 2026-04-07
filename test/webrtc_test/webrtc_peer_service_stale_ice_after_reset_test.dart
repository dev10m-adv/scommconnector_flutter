import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRTC ICE queueing', () {
    test(
      'discards stale ICE after a connection reset without throwing',
      runStaleIceAfterConnectionResetScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}