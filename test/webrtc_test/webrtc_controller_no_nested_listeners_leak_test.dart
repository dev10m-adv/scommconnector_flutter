import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC recovery orchestration', () {
    test(
      'does not leak nested connection listeners across repeated cycles',
      runNoNestedListenersLeakScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}