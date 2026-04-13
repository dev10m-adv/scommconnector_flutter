import '../repositories/auth_repository.dart';

class GetAccessTokenUseCase {
  final AuthRepository repository;

  const GetAccessTokenUseCase(this.repository);

  Future<String?> call(String email) {
    return repository.getStoredAccessToken(email: email);
  }
}
