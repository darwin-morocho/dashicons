import '../../failures/sign_up_failure.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../typedefs.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<SignUpFailure, User> call() => _repository.signInWithGoogle();
}
