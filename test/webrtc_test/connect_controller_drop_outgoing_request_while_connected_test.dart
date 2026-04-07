import 'package:test/test.dart';

import 'connect_controller_test_support.dart';

void main() {
  group('ConnectController duplicate outgoing requests', () {
    test(
      'drops a repeated outgoing connection request to the same peer while already connected',
      runDropOutgoingConnectionRequestWhileConnectedScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}