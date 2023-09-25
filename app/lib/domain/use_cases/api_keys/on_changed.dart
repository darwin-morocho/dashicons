import '../../models/api_key.dart';
import '../../repositories/api_keys_repository.dart';

class OnApiKeysChangedUseCase {
  OnApiKeysChangedUseCase(this._repository);

  final ApiKeysRepository _repository;

  Stream<List<ApiKey>> call() => _repository.onChanged;
}
