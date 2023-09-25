import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class GetUserPackagesUseCase {
  GetUserPackagesUseCase(this._repository);

  final PackagesRepository _repository;

  Future<List<Package>?> call() {
    return _repository.getPackages();
  }
}
