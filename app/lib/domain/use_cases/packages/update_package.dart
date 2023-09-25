import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class UpdatePackageUseCase {
  UpdatePackageUseCase(this._repository);

  final PackagesRepository _repository;

  Future<bool> call(Package package) {
    return _repository.updatePackage(package);
  }
}
