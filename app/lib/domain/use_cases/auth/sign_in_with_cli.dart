import '../../failures/http_request_failure.dart';
import '../../repositories/auth_repository.dart';
import '../../typedefs.dart';

class SignInWithCliUseCase {
  SignInWithCliUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<HttpRequestFailure, String> call({
    required String email,
    required String apiKey,
    required String oobCode,
  }) {
    return _repository.signInWithCLI(
      apiKey: apiKey,
      oobCode: oobCode,
      email: email,
    );
  }
}
