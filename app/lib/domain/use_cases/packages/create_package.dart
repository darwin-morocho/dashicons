import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class CreatePackageUseCase {
  CreatePackageUseCase(this._repository);

  final PackagesRepository _repository;

  Future<Package?> call(Package package) {
    return _repository.createPackage(package);
  }
}
