import '../repositories/identity_repository.dart';
import 'params/delete_device_params.dart';

class DeleteDeviceUseCase {
  final IdentityRepository repository;

  const DeleteDeviceUseCase(this.repository);

  Future<String> call(DeleteDeviceParams params) {
    return repository.deleteDevice(deviceId: params.deviceId);
  }
}
