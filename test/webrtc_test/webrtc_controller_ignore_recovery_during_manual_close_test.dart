import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC controller lifecycle', () {
    test(
      'ignores internet recovery callbacks during manual close',
      runIgnoreInternetRecoveryDuringManualCloseScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}