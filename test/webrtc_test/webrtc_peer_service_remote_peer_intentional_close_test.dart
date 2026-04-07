import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRTC remote close recovery', () {
    test(
      'accepts a fresh new offer after the remote peer intentionally closes',
      runRemotePeerIntentionalCloseFreshOfferScenario,
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}