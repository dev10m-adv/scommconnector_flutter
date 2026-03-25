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
}
