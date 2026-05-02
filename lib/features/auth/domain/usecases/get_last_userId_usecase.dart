import 'package:scommconnector/features/auth/auth.dart';

class GetLastUsedUserIdUseCase {
  final AuthRepository repository;

  GetLastUsedUserIdUseCase(this.repository);

  Future<String?> call() {
    return repository.getLastUserEmail();
  }
}
