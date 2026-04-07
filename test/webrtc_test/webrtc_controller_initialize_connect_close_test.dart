import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC controller lifecycle', () {
    test(
      'initialize then connect then close stays clean and does not re-trigger recovery',
      runInitializeConnectCloseScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}