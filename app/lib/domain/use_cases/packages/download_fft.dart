import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class DownloadFontUseCase {
  DownloadFontUseCase(this._repository);

  final PackagesRepository _repository;

  Future<void> call(Package package) {
    return _repository.downloadSelectedIconsFont(package);
  }
}
