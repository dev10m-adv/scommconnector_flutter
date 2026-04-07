import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC disconnect recovery', () {
    test(
      'temporary disconnect recovers without hard failure',
      runTemporaryDisconnectAutoRecoverScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}