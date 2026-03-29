import 'package:get_it/get_it.dart';
import 'package:scommconnector/core/config/webrtc_config.dart';
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

final getIt = GetIt.instance;

Future<void> setupDependencies({
  String host = ScommConfig.grocHost,
  int port = ScommConfig.grocPort,
  bool useTls = false,
}) async {
  // Build DI graph in an idempotent way so partial previous setup does not
  // leave missing registrations (for example, auth chain absent while
  // AuthSessionState is already registered).
  if (!getIt.isRegistered<AuthServiceGrpcClientImpl>() ||
      !getIt.isRegistered<AuthServiceGrpcClient>()) {
    await authDI(getIt, host, port, useTls);
  }

  if (!getIt.isRegistered<AuthSessionState>() ||
      !getIt.isRegistered<IdentityController>()) {
    await identityDI(getIt, host, port, useTls);
  }

  if (!getIt.isRegistered<SignalingController>()) {
    await signalingDI(getIt, host, port, useTls);
  }

  if (!getIt.isRegistered<WebRtcController>()) {
    await webrtcDI(getIt);
  }

  if (!getIt.isRegistered<ConnectController>()) {
    await connectDI(getIt);
  }
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
