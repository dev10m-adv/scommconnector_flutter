import 'package:scommconnector/features/identity/domain/entities/identity_device.dart';
import '../repositories/identity_repository.dart';

class ListAllowUserDevicesUsecase {
  final IdentityRepository repository;

  const ListAllowUserDevicesUsecase(this.repository);

  Future<List<IdentityDevice>> call({required String deviceId}) {

    return repository.listAllowUserDevices(deviceId: deviceId);
  }
}
