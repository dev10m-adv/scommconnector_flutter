import '../../domain/entities/device_mode.dart';
import '../../domain/entities/identity_device.dart';

class DeviceModel {
  final String deviceId;
  final String userId;
  final String deviceName;
  final String deviceType;
  final DeviceMode mode;

  const DeviceModel({
    required this.deviceId,
    required this.userId,
    required this.deviceName,
    required this.deviceType,
    required this.mode,
  });

  IdentityDevice toEntity() {
    return IdentityDevice(
      deviceId: deviceId,
      userId: userId,
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
  }
}
