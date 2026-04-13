import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_server_config.dart';

class ScommStartConfig {
  final String deviceId;
  final String serverAddress;
  final int serverPort;
  final bool useTls;
  final String email;

  final List<WebRtcIceServerConfig> iceServers;

   ScommStartConfig({
    required this.deviceId,
    required this.serverAddress,
    required this.serverPort,
    required this.useTls,
    required this.iceServers,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'serverAddress': serverAddress,
      'serverPort': serverPort,
      'useTls': useTls,
      'iceServers': iceServers.map((e) => e.toJson()).toList(),
      'email': email,
    };
  }

  factory ScommStartConfig.fromJson(Map<String, dynamic> json) {
    return ScommStartConfig(
      deviceId: json['deviceId'] as String,
      serverAddress: json['serverAddress'] as String,
      serverPort: json['serverPort'] as int,
      useTls: json['useTls'] as bool,
      iceServers: (json['iceServers'] as List<dynamic>)
          .map((e) => WebRtcIceServerConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String,
    );
  }
}

sealed class ScommLoginConfig {
  final String provider;
  ScommLoginConfig({
    required this.provider,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
    };
  }
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

  @override
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
  final String email;

  ScommTokenExchangeLoginConfig({
    required this.provider,
    required this.externalAccessToken,
    required this.email,
  }) : super(provider: provider);

  @override
  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'externalAccessToken': externalAccessToken,
      'email': email,
    };
  }

  factory ScommTokenExchangeLoginConfig.fromJson(Map<String, dynamic> json) {
    return ScommTokenExchangeLoginConfig(
      provider: json['provider'] as String,
      externalAccessToken: json['externalAccessToken'] as String,
      email: json['email'] as String,
    );
  }
}