export 'package:scommconnector/core/errors/errors.dart';
export 'package:scommconnector/core/di/service_locator.dart';
export 'package:scommconnector/core/config/webrtc_config.dart';


export 'package:scommconnector/features/auth/auth.dart';
export 'package:scommconnector/features/webrtc/webrtc.dart';
export 'package:scommconnector/features/identity/identity.dart';
export 'package:scommconnector/features/signaling/signaling.dart';
export 'package:scommconnector/features/connect/connect_controller.dart';
export 'package:scommconnector/features/connect/datachannel/scomm_datachannel_protocol.dart';
export 'package:scommconnector/features/connect/datachannel/scomm_message_router.dart';
export 'package:scommconnector/features/connect/datachannel/scomm_datachannel_transport.dart';
export 'package:scommconnector/features/connect/datachannel/scomm_datachannel_controller.dart';


import 'package:scommconnector/core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> runScommConnectorDI(String host, int port, bool useTls) async {
  await setupDependencies(host: host, port: port, useTls: useTls);
}


Future<void> clearCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}