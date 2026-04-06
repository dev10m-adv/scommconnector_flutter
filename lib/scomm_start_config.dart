import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';

class ScommStartConfig {
  final String deviceId;
  final String serverAddress;
  final String userId;
  final int serverPort;
  final bool useTls;

  final List<WebRtcIceServerConfig> iceServers;

   ScommStartConfig({
    required this.deviceId,
    required this.serverAddress,
    required this.userId,
    required this.serverPort,
    required this.useTls,
    required this.iceServers,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'serverAddress': serverAddress,
      'userId': userId,
      'serverPort': serverPort,
      'useTls': useTls,
      'iceServers': iceServers.map((e) => e.toJson()).toList(),
    };
  }

  factory ScommStartConfig.fromJson(Map<String, dynamic> json) {
    return ScommStartConfig(
      deviceId: json['deviceId'] as String,
      serverAddress: json['serverAddress'] as String,
      userId: json['userId'] as String,
      serverPort: json['serverPort'] as int,
      useTls: json['useTls'] as bool,
      iceServers: (json['iceServers'] as List<dynamic>)
          .map((e) => WebRtcIceServerConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

sealed class ScommLoginConfig {
  final String provider;
  ScommLoginConfig({
    required this.provider,
  });
}

class ScommImapLoginConfig extends ScommLoginConfig {
  final String email;
  final String password;
  final String host;
  final int port;
  final bool useTls;

  ScommImapLoginConfig({
    required this.email,
    required this.password,
    required this.host,
    required this.port,
    required this.useTls,
  }) : super(provider: 'imap');

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'email': email,
      'password': password,
      'host': host,
      'port': port,
      'useTls': useTls,
    };
  }

  factory ScommImapLoginConfig.fromJson(Map<String, dynamic> json) {
    return ScommImapLoginConfig(
      email: json['email'] as String,
      password: json['password'] as String,
      host: json['host'] as String,
      port: json['port'] as int,
      useTls: json['useTls'] as bool,
    );
  }
}

class ScommTokenExchangeLoginConfig extends ScommLoginConfig {
  final String provider;
  final String externalAccessToken;
  final String userId;

  ScommTokenExchangeLoginConfig({
    required this.provider,
    required this.externalAccessToken,
    required this.userId,
  }) : super(provider: provider);

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'externalAccessToken': externalAccessToken,
      'userId': userId,
    };
  }

  factory ScommTokenExchangeLoginConfig.fromJson(Map<String, dynamic> json) {
    return ScommTokenExchangeLoginConfig(
      provider: json['provider'] as String,
      externalAccessToken: json['externalAccessToken'] as String,
      userId: json['userId'] as String,
    );
  }
}