import '../../failures/http_request_failure.dart';
import '../../repositories/auth_repository.dart';
import '../../typedefs.dart';

class SendResetPasswordEmailUseCase {
  SendResetPasswordEmailUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<HttpRequestFailure, void> call(String email) {
    return _repository.sendResetPasswordEmail(email);
  }
}
