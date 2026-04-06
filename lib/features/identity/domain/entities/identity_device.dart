import 'device_mode.dart';

class IdentityDevice {
  final String deviceId;
  final String userId;
  final String deviceName;
  final String deviceType;
  final DeviceMode mode;

  const IdentityDevice({
    required this.deviceId,
    required this.userId,
    required this.deviceName,
    required this.deviceType,
    required this.mode,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'userId': userId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'mode': mode.toString().split('.').last, // Convert enum to string
    };
  }

  factory IdentityDevice.fromJson(Map<String, dynamic> json) {
    return IdentityDevice(
      deviceId: json['deviceId'] as String,
      userId: json['userId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      mode: DeviceMode.values.firstWhere(
        (e) => e.toString().split('.').last == (json['mode'] as String),
        orElse: () => DeviceMode.unspecified,
      ),
    );
  }
}
