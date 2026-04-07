import 'package:test/test.dart';

import 'connect_controller_test_support.dart';

void main() {
  group('ConnectController duplicate incoming requests', () {
    test(
      'drops a new connection request from the same peer while already connected',
      runDropNewConnectionRequestWhileConnectedScenario,
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}