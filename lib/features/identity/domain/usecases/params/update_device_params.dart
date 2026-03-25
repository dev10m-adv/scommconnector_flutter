import '../../entities/device_mode.dart';

class UpdateDeviceParams {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final DeviceMode mode;

  const UpdateDeviceParams({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.mode,
  });
}
