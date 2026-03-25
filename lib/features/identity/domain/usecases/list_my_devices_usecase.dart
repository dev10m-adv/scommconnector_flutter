import '../entities/identity_device.dart';
import '../repositories/identity_repository.dart';

class ListMyDevicesUseCase {
  final IdentityRepository repository;

  const ListMyDevicesUseCase(this.repository);

  Future<List<IdentityDevice>> call() {
    return repository.listMyDevices();
  }
}
