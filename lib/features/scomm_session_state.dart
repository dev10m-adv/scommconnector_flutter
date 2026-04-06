import 'package:scommconnector/features/auth/auth.dart';
import 'package:scommconnector/features/identity/identity.dart';
import 'package:scommconnector/features/signaling/signaling.dart';
import 'package:scommconnector/features/webrtc/webrtc.dart';

class ScommSessionState {
  final bool isAuthenticated;
  final bool isDeviceRegistered;
  final AuthState authState;
  final IdentityState identityState;
  final SignalingState signalingState;
  final WebRtcState webRtcState;

  const ScommSessionState({
    required this.isAuthenticated,
    required this.isDeviceRegistered,
    required this.authState,
    required this.identityState,
    required this.signalingState,
    required this.webRtcState,
  });

  bool get canStartRealtime => isAuthenticated && isDeviceRegistered;

  ScommSessionState copyWith({
    bool? isAuthenticated,
    bool? isDeviceRegistered,
    AuthState? authState,
    IdentityState? identityState,
    SignalingState? signalingState,
    WebRtcState? webRtcState,
  }) {
    return ScommSessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isDeviceRegistered: isDeviceRegistered ?? this.isDeviceRegistered,
      authState: authState ?? this.authState,
      identityState: identityState ?? this.identityState,
      signalingState: signalingState ?? this.signalingState,
      webRtcState: webRtcState ?? this.webRtcState,
    );
  }

  factory ScommSessionState.initial() {
    return ScommSessionState(
      isAuthenticated: false,
      isDeviceRegistered: false,
      authState: AuthState.initial(),
      identityState: IdentityState.initial(),
      signalingState: SignalingState.initial(),
      webRtcState: WebRtcState.initial(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'isAuthenticated': isAuthenticated,
      'isDeviceRegistered': isDeviceRegistered,
      'authState': authState.toJson(),
      'identityState': identityState.toJson(),
      'signalingState': signalingState.toJson(),
      'webRtcState': webRtcState.toJson(),
    };
  }

  factory ScommSessionState.fromJson(Map<String, dynamic> json) {
    return ScommSessionState(
      isAuthenticated: json['isAuthenticated'] as bool,
      isDeviceRegistered: json['isDeviceRegistered'] as bool,
      authState: AuthState.fromJson(json['authState'] as Map<String, dynamic>),
      identityState:
          IdentityState.fromJson(json['identityState'] as Map<String, dynamic>),
      signalingState:
          SignalingState.fromJson(json['signalingState'] as Map<String, dynamic>),
      webRtcState:
          WebRtcState.fromJson(json['webRtcState'] as Map<String, dynamic>),
    );
  }
}