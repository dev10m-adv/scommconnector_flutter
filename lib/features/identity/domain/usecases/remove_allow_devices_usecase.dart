import 'package:scommconnector/features/identity/domain/repositories/identity_repository.dart';

class RemoveAllowUserDeviceUsecase {
  final IdentityRepository repository;

  const RemoveAllowUserDeviceUsecase(this.repository);

  Future<String> call({required String userId, required String deviceId}) {
    return repository.removeAllowUserDevice(userId: userId, deviceId: deviceId);
  }
}
