import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'save_file_service.dart';

class SaveFileMacOsSerive extends SaveFileService {
  @override
  Future<void> saveFile(String fileName, Uint8List bytes) async {
    try {
      final filePath = await FilePicker.platform.saveFile(
        fileName: fileName,
      );
      if (filePath != null) {
        final file = File(filePath);
        await file.writeAsBytes(bytes);
      }
    } catch (e, s) {
      log(
        e.toString(),
        stackTrace: s,
      );
    }
  }
}
