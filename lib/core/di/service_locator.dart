import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:scommconnector/core/di/feature/auth_di.dart';
import 'package:scommconnector/core/di/feature/connect_di.dart';
import 'package:scommconnector/core/di/feature/identity_id.dart';
import 'package:scommconnector/core/di/feature/signaling_di.dart';
import 'package:scommconnector/core/di/feature/webrtc_di.dart';
import 'package:scommconnector/features/auth/auth.dart';
import 'package:scommconnector/features/connect/connect_controller.dart';
import 'package:scommconnector/features/identity/identity.dart';
import 'package:scommconnector/features/signaling/signaling.dart';
import 'package:scommconnector/features/webrtc/webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final scommDi = GetIt.instance;

Future<void> setupDependencies({
  required String host,
  required int port,
  bool useTls = false,
}) async {

  if (!scommDi.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    scommDi.registerLazySingleton<SharedPreferences>(() => prefs);
  }
  if (!scommDi.isRegistered<FlutterSecureStorage>()) {
    final secureStorage = FlutterSecureStorage();
    scommDi.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  }

  // Build DI graph in an idempotent way so partial previous setup does not
  // leave missing registrations (for example, auth chain absent while
  // AuthSessionState is already registered).

  print('Setting up Scomm Connector dependencies...');
  if (!scommDi.isRegistered<AuthServiceGrpcClientImpl>() ||
      !scommDi.isRegistered<AuthServiceGrpcClient>()) {
    await authDI(scommDi, host, port, useTls);
  }

  print('Auth DI setup complete');

  if (!scommDi.isRegistered<AuthSessionState>() ||
      !scommDi.isRegistered<IdentityController>()) {
    await identityDI(scommDi, host, port, useTls);
  }

  print('Identity DI setup complete');

  if (!scommDi.isRegistered<SignalingController>()) {
    await signalingDI(scommDi, host, port, useTls);
  }

  print('Signaling DI setup complete');

  if (!scommDi.isRegistered<WebRtcController>()) {
    await webrtcDI(scommDi);
  }

  print('WebRTC DI setup complete');

  if (!scommDi.isRegistered<ConnectController>()) {
    await connectDI(scommDi);
  }


  print('Connect DI setup complete');
}

class AuthSessionState {
  String _accessToken = '';

  String get accessToken => _accessToken;
  String? get tokenOrNull =>
      _accessToken.trim().isEmpty ? null : _accessToken.trim();

  void setAccessToken(String token) {
    _accessToken = token;
  }
}
