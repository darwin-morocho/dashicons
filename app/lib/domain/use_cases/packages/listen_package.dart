import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class ListenPackageUseCase {
  ListenPackageUseCase(this._repository);

  final PackagesRepository _repository;

  Stream<Package> call(String packageId) {
    return _repository.listenPackageChanges(packageId);
  }
}
