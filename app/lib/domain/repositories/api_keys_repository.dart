import '../failures/http_request_failure.dart';
import '../models/api_key.dart';
import '../typedefs.dart';

abstract class ApiKeysRepository {
  Stream<List<ApiKey>> get onChanged;
  FutureEither<HttpRequestFailure, List<ApiKey>> getApiKeys();
  FutureEither<HttpRequestFailure, String> generate();
  Future<bool> delete(String id);
}
