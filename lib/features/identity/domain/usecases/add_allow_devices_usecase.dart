import 'package:scommconnector/features/identity/domain/entities/identity_device.dart';
import '../repositories/identity_repository.dart';

class AddAllowUserDeviceUsecase {
  final IdentityRepository repository;

  const AddAllowUserDeviceUsecase(this.repository);

  Future<IdentityDevice> call({required String userId, required String deviceId, required String state}) {
    return repository.addAllowUserDevice(userId: userId, deviceId: deviceId, state: state);
  }
}
