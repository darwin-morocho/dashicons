import '../../../../domain/typedefs.dart';
import 'browser_mock_web_service.dart' if (dart.library.js) 'dart:html';

class BrowserWebService {
  void pushState(Json data, String title, String url) {
    window.history.pushState(data, title, url);
  }
}
