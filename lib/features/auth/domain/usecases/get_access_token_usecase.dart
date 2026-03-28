import '../repositories/auth_repository.dart';

class GetAccessTokenUseCase {
  final AuthRepository repository;

  const GetAccessTokenUseCase(this.repository);

  Future<String?> call(String userId) {
    return repository.getStoredAccessToken(userId: userId);
  }
}
