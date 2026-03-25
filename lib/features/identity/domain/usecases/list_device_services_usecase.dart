import '../entities/device_service.dart';
import '../repositories/identity_repository.dart';
import 'params/list_device_services_params.dart';

class ListDeviceServicesUseCase {
  final IdentityRepository repository;

  const ListDeviceServicesUseCase(this.repository);

  Future<List<DeviceService>> call(ListDeviceServicesParams params) {
    return repository.listDeviceServices(deviceId: params.deviceId);
  }
}
