import '../entities/device_service.dart';
import '../repositories/identity_repository.dart';
import 'params/register_service_params.dart';

class RegisterServiceUseCase {
  final IdentityRepository repository;

  const RegisterServiceUseCase(this.repository);

  Future<DeviceService> call(RegisterServiceParams params) {
    return repository.registerService(
      deviceId: params.deviceId,
      serviceName: params.serviceName,
    );
  }
}
