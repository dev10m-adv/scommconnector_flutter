import 'package:scommconnector/features/auth/domain/repositories/auth_repository.dart';

class GetLastUsedUserIdUseCase {
  final AuthRepository repository;

  GetLastUsedUserIdUseCase(this.repository);

  Future<String?> call() {
    return repository.getLastUserEmail();
  }
}