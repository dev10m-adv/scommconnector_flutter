import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC controller lifecycle', () {
    test(
      'runs only one recovery flow when repeated degraded events arrive',
      runSingleRecoveryFlowScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}