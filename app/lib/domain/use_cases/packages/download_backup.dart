import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class DownloadBackupUseCase {
  DownloadBackupUseCase(this._repository);

  final PackagesRepository _repository;

  Future<void> call(Package package) {
    return _repository.downloadBackup(package);
  }
}
