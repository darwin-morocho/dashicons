import '../typedefs.dart';

abstract class BrowserUtilsRepository {
  void pushState(Json data, String title, String url);
}
