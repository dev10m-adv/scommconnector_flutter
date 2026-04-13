import 'package:grpc/grpc.dart';
import '../../../../core/errors/errors.dart';
import '../../domain/entities/device_mode.dart';
import '../models/device_model.dart';
import '../models/device_service_model.dart';
import 'generated/identity/identity.pb.dart' as identity_pb;
import 'generated/identity/identity.pbgrpc.dart' as identity_grpc;
import 'identity_service_grpc_client.dart';

class IdentityServiceGrpcClientImpl implements IdentityServiceGrpcClient {
  final identity_grpc.IdentityServiceClient _client;
  final AccessTokenProvider? _accessTokenProvider;
  IdentityServiceGrpcClientImpl({
    required String host,
    required int port,
    bool useTls = false,
    AccessTokenProvider? accessTokenProvider,
  }) : _client = identity_grpc.IdentityServiceClient(
         ClientChannel(
           host,
           port: port,
           options: ChannelOptions(
             credentials: useTls
                 ? const ChannelCredentials.secure()
                 : const ChannelCredentials.insecure(),
           ),
         ),
       ),
       _accessTokenProvider = accessTokenProvider;

  @override
  Future<DeviceModel> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.RegisterDeviceRequest(
        deviceName: deviceName,
        deviceType: deviceType,
        mode: _toGrpcDeviceMode(mode),
      );

      return _client.registerDevice(
        request,
        options: await _authorizedOptions(),
      );
    });

    if (!response.hasDevice()) {
      throw ServerException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Device registration failed.',
      );
    }

    return _toDeviceModel(response.device);
  }

  @override
  Future<DeviceModel> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.UpdateDeviceRequest(
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
        mode: _toGrpcDeviceMode(mode),
      );

      return _client.updateDevice(request, options: await _authorizedOptions());
    });

    if (!response.hasDevice()) {
      throw ServerException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Device update failed.',
      );
    }

    return _toDeviceModel(response.device);
  }

  @override
  Future<String> deleteDevice({required String deviceId}) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.DeleteDeviceRequest(deviceId: deviceId);
      return _client.deleteDevice(request, options: await _authorizedOptions());
    });

    return response.message.isNotEmpty
        ? response.message
        : 'Device deleted successfully';
  }

  @override
  Future<List<DeviceModel>> listMyDevices() async {
    try {
      final response = await _executeWithNetworkGuard(() async {
        return _client.listMyDevices(
          identity_pb.ListMyDevicesRequest(),
          options: await _authorizedOptions(),
        );
      });

      return response.devices.map(_toDeviceModel).toList(growable: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceServiceModel> registerService({
    required String deviceId,
    required String serviceName,
  }) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.RegisterServiceRequest(
        deviceId: deviceId,
        serviceName: serviceName,
      );

      return _client.registerService(
        request,
        options: await _authorizedOptions(),
      );
    });

    if (!response.hasService()) {
      throw ServerException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Service registration failed.',
      );
    }

    return _toDeviceServiceModel(response.service);
  }

  @override
  Future<List<DeviceServiceModel>> listDeviceServices({
    required String deviceId,
  }) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.ListDeviceServicesRequest(deviceId: deviceId);
      return _client.listDeviceServices(
        request,
        options: await _authorizedOptions(),
      );
    });
    print("Package Side: ${response.services.length}");

    return response.services.map(_toDeviceServiceModel).toList(growable: false);
  }

  @override
  Future<DeviceServiceModel> updateService({
    required String serviceId,
    required String serviceName,
  }) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.UpdateServiceRequest(
        serviceId: serviceId,
        serviceName: serviceName,
      );

      return _client.updateService(
        request,
        options: await _authorizedOptions(),
      );
    });

    if (!response.hasService()) {
      throw ServerException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Service update failed.',
      );
    }

    return _toDeviceServiceModel(response.service);
  }

  @override
  Future<String> deleteService({required String serviceId}) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.DeleteServiceRequest(serviceId: serviceId);
      return _client.deleteService(
        request,
        options: await _authorizedOptions(),
      );
    });

    return response.message.isNotEmpty
        ? response.message
        : 'Service deleted successfully';
  }

  identity_pb.DeviceMode _toGrpcDeviceMode(DeviceMode mode) {
    switch (mode) {
      case DeviceMode.client:
        return identity_pb.DeviceMode.CLIENT;
      case DeviceMode.provider:
        return identity_pb.DeviceMode.PROVIDER;
      case DeviceMode.hybrid:
        return identity_pb.DeviceMode.HYBRID;
      case DeviceMode.unspecified:
        return identity_pb.DeviceMode.DEVICE_MODE_UNSPECIFIED;
    }
  }

  DeviceMode _fromGrpcDeviceMode(identity_pb.DeviceMode mode) {
    switch (mode) {
      case identity_pb.DeviceMode.CLIENT:
        return DeviceMode.client;
      case identity_pb.DeviceMode.PROVIDER:
        return DeviceMode.provider;
      case identity_pb.DeviceMode.HYBRID:
        return DeviceMode.hybrid;
      case identity_pb.DeviceMode.DEVICE_MODE_UNSPECIFIED:
      default:
        return DeviceMode.unspecified;
    }
  }

  DeviceModel _toDeviceModel(identity_pb.Device device) {
    return DeviceModel(
      deviceId: device.deviceId,
      userId: device.userId,
      deviceName: device.deviceName,
      deviceType: device.deviceType,
      mode: _fromGrpcDeviceMode(device.mode),
    );
  }

  DeviceServiceModel _toDeviceServiceModel(identity_pb.Service service) {
    return DeviceServiceModel(
      serviceId: service.serviceId,
      deviceId: service.deviceId,
      serviceName: service.serviceName,
    );
  }

  Future<CallOptions> _authorizedOptions() async {
    final accessToken = await _accessTokenProvider?.call();
    if (accessToken == null || accessToken.isEmpty) {
      throw const UnauthorizedException();
    }

    return CallOptions(
      metadata: <String, String>{'authorization': 'Bearer $accessToken'},
    );
  }

  Future<T> _executeWithNetworkGuard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on GrpcError catch (error) {
      throw _mapGrpcError(error);
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }
      throw const UnknownAppException();
    }
  }

  AppException _mapGrpcError(GrpcError error) {

    switch (error.code) {
      case StatusCode.deadlineExceeded:
        return const RequestTimeoutException();
      case StatusCode.unavailable:
        return const NoConnectionException();
      case StatusCode.unauthenticated:
      case StatusCode.permissionDenied:
        return const UnauthorizedException();
      case StatusCode.internal:
      case StatusCode.unknown:
      case StatusCode.aborted:
      case StatusCode.resourceExhausted:
      case StatusCode.notFound:
      case StatusCode.failedPrecondition:
      case StatusCode.invalidArgument:
        return const ServerException();
      default:
        return const UnknownAppException();
    }
  }
  
  @override
  Future<DeviceModel> addAllowUserDevice({required String userId, required String deviceId, required String state}) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.AddAllowUserDeviceRequest(
        userId: userId,
        deviceId: deviceId,
        state: state,
      );

      return _client.addAllowUserDevice(
        request,
        options: await _authorizedOptions(),
      );
    });
    return _toDeviceModel(response.device);
  }
  
  @override
  Future<List<DeviceModel>> listAllowUserDevices({required String deviceId}) async {
    print("Listing allow user devices for deviceId: $deviceId");
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.ListAllowUserDevicesRequest(deviceId: deviceId);
      return _client.listAllowUserDevices(
        request,
        options: await _authorizedOptions(),
      );
    });

    return response.devices.map(_toDeviceModel).toList(growable: false);
  }
  
  @override
  Future<String> removeAllowUserDevice({required String userId, required String deviceId}) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.RemoveAllowUserDeviceRequest(
        userId: userId,
        deviceId: deviceId,
      );
      return _client.removeAllowUserDevice(
        request,
        options: await _authorizedOptions(),
      );
    });

    return response.message.isNotEmpty
        ? response.message
        : 'Allowed user device removed successfully';
  }
  
  @override
  Future<DeviceModel> updateAllowUserDevice({required String userId, required String deviceId, required String state}) async {
    final response = await _executeWithNetworkGuard(() async {
      final request = identity_pb.UpdateAllowUserDeviceRequest(
        userId: userId,
        deviceId: deviceId,
        state: state,
      );

      return _client.updateAllowUserDevice(
        request,
        options: await _authorizedOptions(),
      );
    });

    if (!response.hasDevice()) {
      throw ServerException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Allowed user device update failed.',
      );
    }

    return _toDeviceModel(response.device);
  }
}
