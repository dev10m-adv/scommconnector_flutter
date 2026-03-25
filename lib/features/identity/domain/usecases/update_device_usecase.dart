import '../entities/identity_device.dart';
import '../repositories/identity_repository.dart';
import 'params/update_device_params.dart';

class UpdateDeviceUseCase {
  final IdentityRepository repository;

  const UpdateDeviceUseCase(this.repository);

  Future<IdentityDevice> call(UpdateDeviceParams params) {
    return repository.updateDevice(
      deviceId: params.deviceId,
      deviceName: params.deviceName,
      deviceType: params.deviceType,
      mode: params.mode,
    );
  }
}
