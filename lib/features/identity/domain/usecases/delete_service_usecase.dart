import '../repositories/identity_repository.dart';
import 'params/delete_service_params.dart';

class DeleteServiceUseCase {
  final IdentityRepository repository;

  const DeleteServiceUseCase(this.repository);

  Future<String> call(DeleteServiceParams params) {
    return repository.deleteService(serviceId: params.serviceId);
  }
}
