export 'package:scommconnector/core/errors/errors.dart';
export 'package:scommconnector/core/di/service_locator.dart';
export 'package:scommconnector/core/config/webrtc_config.dart';


export 'package:scommconnector/features/auth/auth.dart';
export 'package:scommconnector/features/webrtc/webrtc.dart';
export 'package:scommconnector/features/identity/identity.dart';
export 'package:scommconnector/features/signaling/signaling.dart';
export 'package:scommconnector/features/network/connect_controller.dart';


import 'package:scommconnector/core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
typedef AuthSessionState = TestSessionState;
Future<void> runScommConnectorDI() async {
  await setupDependencies();
}


Future<void> clearCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}