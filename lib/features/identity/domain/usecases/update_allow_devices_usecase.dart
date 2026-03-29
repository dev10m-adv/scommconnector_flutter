import 'package:scommconnector/features/identity/domain/entities/identity_device.dart';
import 'package:scommconnector/features/identity/domain/repositories/identity_repository.dart';

class UpdateAllowUserDeviceUsecase {
  final IdentityRepository repository;

  const UpdateAllowUserDeviceUsecase(this.repository);

  Future<IdentityDevice> call({required String userId, required String deviceId, required String state}) {
    return repository.updateAllowUserDevice(userId: userId, deviceId: deviceId, state: state);
  }
}