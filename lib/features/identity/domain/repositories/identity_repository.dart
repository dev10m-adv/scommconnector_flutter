import '../entities/device_mode.dart';
import '../entities/device_service.dart';
import '../entities/identity_device.dart';
import '../entities/saved_device_identity.dart';

abstract class IdentityRepository {
  Future<IdentityDevice> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  });

  Future<SavedDeviceIdentity?> loadSavedDeviceIdentity();

  Future<IdentityDevice> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  });

  Future<String> deleteDevice({required String deviceId});

  Future<List<IdentityDevice>> listMyDevices();

  Future<List<IdentityDevice>> listUserDevices({required String userId});

  Future<DeviceService> registerService({
    required String deviceId,
    required String serviceName,
  });

  Future<List<DeviceService>> listDeviceServices({required String deviceId});

  Future<DeviceService> updateService({
    required String serviceId,
    required String serviceName,
  });

  Future<String> deleteService({required String serviceId});
}
