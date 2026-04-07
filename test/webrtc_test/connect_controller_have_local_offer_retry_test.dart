import 'package:test/test.dart';

import 'connect_controller_test_support.dart';

void main() {
  group('ConnectController incoming offers', () {
    test(
      'retries once after a have-local-offer collision by resetting WebRTC',
      runIncomingOfferRetriesAfterHaveLocalOfferScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}