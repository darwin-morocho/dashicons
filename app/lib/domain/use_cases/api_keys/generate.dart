import '../../failures/http_request_failure.dart';
import '../../repositories/api_keys_repository.dart';
import '../../typedefs.dart';

class GenerateApiKeyUseCase {
  GenerateApiKeyUseCase(this._repository);

  final ApiKeysRepository _repository;

  FutureEither<HttpRequestFailure, String> call() => _repository.generate();
}
