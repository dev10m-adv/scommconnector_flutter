import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC recovery orchestration', () {
    test(
      'closes cleanly after max recovery attempts are exhausted',
      runMaxRecoveryAttemptsExhaustedScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}