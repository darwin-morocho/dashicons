import 'dart:developer';
import 'dart:typed_data';

import 'save_file_mock_web_service.dart' if (dart.library.js) 'dart:html';
import 'save_file_service.dart';

class SaveFileWebService extends SaveFileService {
  @override
  Future<void> saveFile(String fileName, Uint8List bytes) async {
    try {
      final blob = Blob([bytes]);
      final url = Url.createObjectUrlFromBlob(blob);
      final anchor = document.createElement('a') as AnchorElement
        ..href = url
        ..download = fileName;
      document.body!.append(anchor);
      anchor.click();
      Url.revokeObjectUrl(url);
    } catch (e, s) {
      log(
        e.toString(),
        stackTrace: s,
      );
    }
  }
}
