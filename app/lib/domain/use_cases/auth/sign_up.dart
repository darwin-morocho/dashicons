import '../../failures/sign_up_failure.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../typedefs.dart';

class SignUpUseCase {
  SignUpUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<SignUpFailure, User> call({
    required String email,
    required String fullName,
    required String password,
  }) {
    return _repository.signUp(
      User(
        id: '',
        fullName: fullName,
        email: email,
      ),
      password,
    );
  }
}
