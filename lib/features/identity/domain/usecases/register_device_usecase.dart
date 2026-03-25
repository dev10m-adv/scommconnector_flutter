import '../entities/identity_device.dart';
import '../repositories/identity_repository.dart';
import 'params/register_device_params.dart';

class RegisterDeviceUseCase {
  final IdentityRepository repository;

  const RegisterDeviceUseCase(this.repository);

  Future<IdentityDevice> call(RegisterDeviceParams params) {
    return repository.registerDevice(
      deviceName: params.deviceName,
      deviceType: params.deviceType,
      mode: params.mode,
    );
  }
}
