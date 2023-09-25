import '../../repositories/browser_utils_repository.dart';

class UpdateBrowserUrlUseCase {
  UpdateBrowserUrlUseCase(this._repository);

  final BrowserUtilsRepository _repository;

  void call(String title, String url) {
    _repository.pushState({}, title, url);
  }
}
