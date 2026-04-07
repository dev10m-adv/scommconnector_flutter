import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRTC ICE queueing', () {
    test(
      'queues ICE candidates that arrive before the remote description',
      runIceCandidateQueuedUntilRemoteDescriptionScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}