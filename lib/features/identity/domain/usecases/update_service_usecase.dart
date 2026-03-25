import '../entities/device_service.dart';
import '../repositories/identity_repository.dart';
import 'params/update_service_params.dart';

class UpdateServiceUseCase {
  final IdentityRepository repository;

  const UpdateServiceUseCase(this.repository);

  Future<DeviceService> call(UpdateServiceParams params) {
    return repository.updateService(
      serviceId: params.serviceId,
      serviceName: params.serviceName,
    );
  }
}
