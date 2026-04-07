import 'package:test/test.dart';

import 'connect_controller_test_support.dart';

void main() {
  group('ConnectController incoming offers', () {
    test(
      'resets the old WebRTC session before answering a fresh incoming offer',
      runFreshIncomingOfferResetsOldSessionScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}