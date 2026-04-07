import 'package:test/test.dart';

import 'connect_controller_test_support.dart';

void main() {
  group('ConnectController duplicate incoming requests', () {
    test(
      'drops a new offer from the same peer while already connected',
      runDropNewIncomingOfferWhileConnectedScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}