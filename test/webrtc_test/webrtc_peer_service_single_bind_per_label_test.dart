import 'package:test/test.dart';

import 'webrtc_peer_service_test_support.dart';

void main() {
  group('WebRtcPeerService data channel correctness', () {
    test(
      'keeps a single logical main channel per label and delivers one message each way',
      runSingleBindPerLabelScenario,
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
