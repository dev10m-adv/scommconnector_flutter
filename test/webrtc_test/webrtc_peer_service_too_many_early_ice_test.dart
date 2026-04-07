import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRTC ICE queueing', () {
    test(
      'drops the oldest queued ICE candidates when the pending limit is exceeded',
      runTooManyEarlyIceCandidatesScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}