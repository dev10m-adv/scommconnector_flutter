import '../../domain/entities/device_mode.dart';
import '../models/device_model.dart';
import '../models/device_service_model.dart';

typedef AccessTokenProvider = Future<String?> Function();

abstract class IdentityServiceGrpcClient {
  Future<DeviceModel> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  });

  Future<DeviceModel> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  });

  Future<String> deleteDevice({required String deviceId});

  Future<List<DeviceModel>> listMyDevices();

  Future<List<DeviceModel>> listUserDevices({required String userId});

  Future<DeviceServiceModel> registerService({
    required String deviceId,
    required String serviceName,
  });

  Future<List<DeviceServiceModel>> listDeviceServices({
    required String deviceId,
  });

  Future<DeviceServiceModel> updateService({
    required String serviceId,
    required String serviceName,
  });

  Future<String> deleteService({required String serviceId});


  //// Allow User Devices
  Future<List<DeviceModel>> listAllowUserDevices({required String deviceId});
  Future<DeviceModel> addAllowUserDevice({
    required String userId,
    required String deviceId,
    required String state,
  });

  Future<String> removeAllowUserDevice({
    required String userId,
    required String deviceId,
  });

  Future<DeviceModel> updateAllowUserDevice({
    required String userId,
    required String deviceId,
    required String state,
  });
}
