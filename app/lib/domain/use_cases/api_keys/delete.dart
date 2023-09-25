import '../../repositories/api_keys_repository.dart';

class DeleteApiKeyUseCase {
  DeleteApiKeyUseCase(this._repository);

  final ApiKeysRepository _repository;

  Future<bool> call(String id) => _repository.delete(id);
}
