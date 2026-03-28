import '../../domain/entities/device_mode.dart';
import '../../domain/entities/device_service.dart';
import '../../domain/entities/identity_device.dart';
import '../../domain/entities/saved_device_identity.dart';
import '../../domain/repositories/identity_repository.dart';
import '../datasources/local/identity_local_datasource.dart';
import '../datasources/remote/identity_remote_datasource.dart';

class IdentityRepositoryImpl implements IdentityRepository {
  final IdentityRemoteDataSource remoteDataSource;
  final IdentityLocalDataSource localDataSource;

  const IdentityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<IdentityDevice> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    final response = await remoteDataSource.registerDevice(
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
    final device = response.toEntity();
    await localDataSource.saveRegisteredDeviceIdentity(
      userId: device.userId,
      deviceId: device.deviceId,
    );
    return device;
  }

  @override
  Future<SavedDeviceIdentity?> loadSavedDeviceIdentity(String userId) async {
    final saved = await localDataSource.loadRegisteredDeviceIdentity(userId);
    if (saved == null) {
      return null;
    }

    return SavedDeviceIdentity(userId: saved.userId, deviceId: saved.deviceId);
  }

  @override
  Future<IdentityDevice> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    final response = await remoteDataSource.updateDevice(
      deviceId: deviceId,
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
    return response.toEntity();
  }

  @override
  Future<String> deleteDevice({required String deviceId}) {
    return remoteDataSource.deleteDevice(deviceId: deviceId);
  }

  @override
  Future<List<IdentityDevice>> listMyDevices() async {
    final response = await remoteDataSource.listMyDevices();
    return response.map((device) => device.toEntity()).toList(growable: false);
  }

  @override
  Future<List<IdentityDevice>> listUserDevices({required String userId}) async {
    final response = await remoteDataSource.listUserDevices(userId: userId);
    return response.map((device) => device.toEntity()).toList(growable: false);
  }

  @override
  Future<DeviceService> registerService({
    required String deviceId,
    required String serviceName,
  }) async {
    final response = await remoteDataSource.registerService(
      deviceId: deviceId,
      serviceName: serviceName,
    );
    return response.toEntity();
  }

  @override
  Future<List<DeviceService>> listDeviceServices({
    required String deviceId,
  }) async {
    final response = await remoteDataSource.listDeviceServices(
      deviceId: deviceId,
    );
    return response
        .map((service) => service.toEntity())
        .toList(growable: false);
  }

  @override
  Future<DeviceService> updateService({
    required String serviceId,
    required String serviceName,
  }) async {
    final response = await remoteDataSource.updateService(
      serviceId: serviceId,
      serviceName: serviceName,
    );
    return response.toEntity();
  }

  @override
  Future<String> deleteService({required String serviceId}) {
    return remoteDataSource.deleteService(serviceId: serviceId);
  }
}
