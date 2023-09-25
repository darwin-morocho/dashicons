import '../../models/font_cache.dart';
import '../../models/package.dart';
import '../../repositories/packages_repository.dart';

class GetCachedFontUseCase {
  GetCachedFontUseCase(this._repository);

  final PackagesRepository _repository;

  Future<FontCache?> call(Package package) => _repository.getFontCache(package);
}
