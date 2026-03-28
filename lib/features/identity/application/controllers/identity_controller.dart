import '../../../../core/errors/errors.dart';
import '../../domain/entities/device_mode.dart';
import '../../domain/entities/device_service.dart';
import '../../domain/entities/identity_device.dart';
import '../../domain/entities/saved_device_identity.dart';
import '../../domain/usecases/delete_device_usecase.dart';
import '../../domain/usecases/delete_service_usecase.dart';
import '../../domain/usecases/list_device_services_usecase.dart';
import '../../domain/usecases/list_my_devices_usecase.dart';
import '../../domain/usecases/list_user_devices_usecase.dart';
import '../../domain/usecases/params/delete_device_params.dart';
import '../../domain/usecases/params/delete_service_params.dart';
import '../../domain/usecases/params/list_device_services_params.dart';
import '../../domain/usecases/params/list_user_devices_params.dart';
import '../../domain/usecases/params/register_device_params.dart';
import '../../domain/usecases/params/register_service_params.dart';
import '../../domain/usecases/params/update_device_params.dart';
import '../../domain/usecases/params/update_service_params.dart';
import '../../domain/usecases/register_device_usecase.dart';
import '../../domain/usecases/register_service_usecase.dart';
import '../../domain/usecases/update_device_usecase.dart';
import '../../domain/usecases/update_service_usecase.dart';
import '../state/identity_state.dart';

class IdentityController {
  final RegisterDeviceUseCase registerDeviceUseCase;
  final UpdateDeviceUseCase updateDeviceUseCase;
  final DeleteDeviceUseCase deleteDeviceUseCase;
  final ListMyDevicesUseCase listMyDevicesUseCase;
  final ListUserDevicesUseCase listUserDevicesUseCase;
  final RegisterServiceUseCase registerServiceUseCase;
  final ListDeviceServicesUseCase listDeviceServicesUseCase;
  final UpdateServiceUseCase updateServiceUseCase;
  final DeleteServiceUseCase deleteServiceUseCase;

  IdentityState _state = const IdentityState();

  IdentityController({
    required this.registerDeviceUseCase,
    required this.updateDeviceUseCase,
    required this.deleteDeviceUseCase,
    required this.listMyDevicesUseCase,
    required this.listUserDevicesUseCase,
    required this.registerServiceUseCase,
    required this.listDeviceServicesUseCase,
    required this.updateServiceUseCase,
    required this.deleteServiceUseCase,
  });

  IdentityState get state => _state;

  Future<SavedDeviceIdentity?> loadSavedDeviceIdentity(String userId) async {
    _setLoading();

    try {
      final savedIdentity = await registerDeviceUseCase.repository
          .loadSavedDeviceIdentity(userId);

      _state = _state.copyWith(
        status: IdentityStatus.success,
        savedDeviceIdentity: savedIdentity,
        clearError: true,
        clearMessage: true,
      );

      return savedIdentity;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<IdentityDevice> registerDevice({
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    _setLoading();

    try {
      final device = await registerDeviceUseCase(
        RegisterDeviceParams(
          deviceName: deviceName,
          deviceType: deviceType,
          mode: mode,
        ),
      );
      _setDeviceSuccess(device, 'Device registered successfully');
      return device;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<IdentityDevice> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) async {
    _setLoading();

    try {
      final device = await updateDeviceUseCase(
        UpdateDeviceParams(
          deviceId: deviceId,
          deviceName: deviceName,
          deviceType: deviceType,
          mode: mode,
        ),
      );
      _setDeviceSuccess(device, 'Device updated successfully');
      return device;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<String> deleteDevice({required String deviceId}) async {
    _setLoading();

    try {
      final message = await deleteDeviceUseCase(
        DeleteDeviceParams(deviceId: deviceId),
      );
      _state = _state.copyWith(
        status: IdentityStatus.success,
        message: message,
        clearDevice: true,
        clearError: true,
      );
      return message;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<List<IdentityDevice>> listMyDevices() async {
    _setLoading();

    try {
      final devices = await listMyDevicesUseCase();
      _setDevicesSuccess(devices);
      return devices;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<List<IdentityDevice>> listUserDevices({required String userId}) async {
    _setLoading();

    try {
      final devices = await listUserDevicesUseCase(
        ListUserDevicesParams(userId: userId),
      );
      _setDevicesSuccess(devices);
      return devices;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<DeviceService> registerService({
    required String deviceId,
    required String serviceName,
  }) async {
    _setLoading();

    try {
      final service = await registerServiceUseCase(
        RegisterServiceParams(deviceId: deviceId, serviceName: serviceName),
      );
      _setServiceSuccess(service, 'Service registered successfully');
      return service;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<List<DeviceService>> listDeviceServices({
    required String deviceId,
  }) async {
    _setLoading();

    try {
      final services = await listDeviceServicesUseCase(
        ListDeviceServicesParams(deviceId: deviceId),
      );
      _setServicesSuccess(services);
      return services;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<DeviceService> updateService({
    required String serviceId,
    required String serviceName,
  }) async {
    _setLoading();

    try {
      final service = await updateServiceUseCase(
        UpdateServiceParams(serviceId: serviceId, serviceName: serviceName),
      );
      _setServiceSuccess(service, 'Service updated successfully');
      return service;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<String> deleteService({required String serviceId}) async {
    _setLoading();

    try {
      final message = await deleteServiceUseCase(
        DeleteServiceParams(serviceId: serviceId),
      );
      _state = _state.copyWith(
        status: IdentityStatus.success,
        message: message,
        clearService: true,
        clearError: true,
      );
      return message;
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  void _setLoading() {
    _state = _state.copyWith(
      status: IdentityStatus.loading,
      clearError: true,
      clearMessage: true,
    );
  }

  void _setDeviceSuccess(IdentityDevice device, String message) {
    _state = _state.copyWith(
      status: IdentityStatus.success,
      device: device,
      savedDeviceIdentity: SavedDeviceIdentity(
        userId: device.userId,
        deviceId: device.deviceId,
      ),
      message: message,
      clearError: true,
    );
  }

  void _setDevicesSuccess(List<IdentityDevice> devices) {
    _state = _state.copyWith(
      status: IdentityStatus.success,
      devices: devices,
      clearError: true,
      clearMessage: true,
    );
  }

  void _setServiceSuccess(DeviceService service, String message) {
    _state = _state.copyWith(
      status: IdentityStatus.success,
      service: service,
      message: message,
      clearError: true,
    );
  }

  void _setServicesSuccess(List<DeviceService> services) {
    _state = _state.copyWith(
      status: IdentityStatus.success,
      services: services,
      clearError: true,
      clearMessage: true,
    );
  }

  void _setFailure(Object error) {
    _state = _state.copyWith(
      status: IdentityStatus.failure,
      error: _toUserMessage(error),
    );
  }

  String _toUserMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Identity request failed. Please try again.';
  }
}
