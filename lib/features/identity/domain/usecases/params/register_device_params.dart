import '../../entities/device_mode.dart';

class RegisterDeviceParams {
  final String deviceName;
  final String deviceType;
  final DeviceMode mode;

  const RegisterDeviceParams({
    required this.deviceName,
    required this.deviceType,
    required this.mode,
  });
}
