import 'dart:typed_data';

abstract class SaveFileService {
  Future<void> saveFile(String fileName, Uint8List bytes);
}
