import '../../domain/repositories/browser_utils_repository.dart';
import '../../domain/typedefs.dart';
import '../services/local/browser/browser_web_service.dart';

class BrowserUtilsRepositoryImpl implements BrowserUtilsRepository {
  BrowserUtilsRepositoryImpl(this._browserService);

  final BrowserWebService _browserService;
  @override
  void pushState(Json data, String title, String url) {
    _browserService.pushState(data, title, url);
  }
}
