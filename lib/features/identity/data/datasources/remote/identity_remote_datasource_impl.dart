import '../../../domain/entities/device_mode.dart';
import '../../grpc/identity_service_grpc_client.dart';
import '../../models/device_model.dart';
import '../../models/device_service_model.dart';
import 'identity_remote_datasource.dart';

class IdentityRemoteDataSourceImpl implements IdentityRemoteDataSource {
  final IdentityServiceGrpcClient grpcClient;

  const IdentityRemoteDataSourceImpl({required this.grpcClient});

  @override
  Future<DeviceModel> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) {
    return grpcClient.registerDevice(
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
  }

  @override
  Future<DeviceModel> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) {
    return grpcClient.updateDevice(
      deviceId: deviceId,
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
  }

  @override
  Future<String> deleteDevice({required String deviceId}) {
    return grpcClient.deleteDevice(deviceId: deviceId);
  }

  @override
  Future<List<DeviceModel>> listMyDevices() {
    return grpcClient.listMyDevices();
  }

  @override
  Future<List<DeviceModel>> listUserDevices({required String userId}) {
    return grpcClient.listUserDevices(userId: userId);
  }

  @override
  Future<DeviceServiceModel> registerService({
    required String deviceId,
    required String serviceName,
  }) {
    return grpcClient.registerService(
      deviceId: deviceId,
      serviceName: serviceName,
    );
  }

  @override
  Future<List<DeviceServiceModel>> listDeviceServices({
    required String deviceId,
  }) {
    return grpcClient.listDeviceServices(deviceId: deviceId);
  }

  @override
  Future<DeviceServiceModel> updateService({
    required String serviceId,
    required String serviceName,
  }) {
    return grpcClient.updateService(
      serviceId: serviceId,
      serviceName: serviceName,
    );
  }

  @override
  Future<String> deleteService({required String serviceId}) {
    return grpcClient.deleteService(serviceId: serviceId);
  }
  
  @override
  Future<DeviceModel> addAllowUserDevice({required String userId, required String deviceId, required String state}) {
    return grpcClient.addAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
      state: state,
    );
  }
  
  @override
  Future<List<DeviceModel>> listAllowUserDevices({required String deviceId}) {
    print("RemoteDataSource: Listing allow user devices for deviceId: $deviceId");
    return grpcClient.listAllowUserDevices(deviceId: deviceId);
  }
  
  @override
  Future<String> removeAllowUserDevice({required String userId, required String deviceId}) {
    return grpcClient.removeAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
    );
  }
  
  @override
  Future<DeviceModel> updateAllowUserDevice({required String userId, required String deviceId, required String state}) {
    return grpcClient.updateAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
      state: state,
     );
  }
}
