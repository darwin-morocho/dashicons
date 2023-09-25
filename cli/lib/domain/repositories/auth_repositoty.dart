import '../models/http_result.dart';
import '../models/session.dart';

abstract class AuthRepository {
  Future<HttpResult<void>> requestCredentials(String email);
  Future<HttpResult<void>> sendCredentials({
    required String email,
    required String apiKey,
    required String oobCode,
  });

  Future<Session?> get session;
  Future<void> logout();
}
