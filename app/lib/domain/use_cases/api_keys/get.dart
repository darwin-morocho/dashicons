import '../../failures/http_request_failure.dart';
import '../../models/api_key.dart';
import '../../repositories/api_keys_repository.dart';
import '../../typedefs.dart';

class GetApiKeysUseCase {
  GetApiKeysUseCase(this._repository);

  final ApiKeysRepository _repository;

  FutureEither<HttpRequestFailure, List<ApiKey>> call() => _repository.getApiKeys();
}
