import '../../models/user.dart';
import '../../repositories/auth_repository.dart';

class GetAuthenticatedUserUseCase {
  GetAuthenticatedUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() {
    return _repository.currentUser;
  }
}
