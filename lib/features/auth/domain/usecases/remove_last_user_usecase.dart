import 'package:scommconnector/features/auth/domain/repositories/auth_repository.dart';

class RemoveLastUserUsecase {
  final AuthRepository repository;

  RemoveLastUserUsecase(this.repository);

  Future<void> call() {
    return repository.removeLastUsedUserId();
  }
}