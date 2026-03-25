import '../entities/identity_device.dart';
import '../repositories/identity_repository.dart';
import 'params/list_user_devices_params.dart';

class ListUserDevicesUseCase {
  final IdentityRepository repository;

  const ListUserDevicesUseCase(this.repository);

  Future<List<IdentityDevice>> call(ListUserDevicesParams params) {
    return repository.listUserDevices(userId: params.userId);
  }
}
