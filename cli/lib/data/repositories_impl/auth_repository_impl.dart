import '../../domain/models/http_result.dart';
import '../../domain/models/session.dart';
import '../../domain/repositories/auth_repositoty.dart';
import '../http.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Http _http;
  final AuthService _authService;

  AuthRepositoryImpl(this._http, this._authService);

  @override
  Future<HttpResult<void>> requestCredentials(String email) {
    return _http.send(
      '/api/v1/cli/link',
      method: HttpMethod.post,
      body: {
        'email': email,
      },
      parser: (_, json) => json['message'] as String,
    );
  }

  @override
  Future<HttpResult<Session>> sendCredentials({
    required String email,
    required String apiKey,
    required String oobCode,
  }) async {
    final result = await _http.send(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithEmailLink',
      queryParameters: {
        'key': apiKey,
      },
      method: HttpMethod.post,
      body: {
        'oobCode': oobCode,
        'email': email,
      },
      parser: (_, json) => Session.fromJson({
        ...json,
        'apiKey': apiKey,
      }),
    );

    await result.whenOrNull(
      success: (_, session) async {
        await _authService.saveSession(session);
      },
    );

    return result;
  }

  @override
  Future<Session?> get session => _authService.session;

  @override
  Future<void> logout() => _authService.logout();
}
