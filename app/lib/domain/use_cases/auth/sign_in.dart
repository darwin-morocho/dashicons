import '../../failures/sign_in_failure.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../typedefs.dart';

class SignInUseCase {
  SignInUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<SignInFailure, User> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email, password);
  }
}
