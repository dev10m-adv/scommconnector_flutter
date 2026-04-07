import 'package:test/test.dart';

import 'webrtc_controller_test_support.dart';

void main() {
  group('WebRTC recovery orchestration', () {
    test(
      'starts one reconnect flow for one recovery cycle',
      runReconnectOncePerRecoveryCycleScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}