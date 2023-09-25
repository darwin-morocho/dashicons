import 'dart:convert';

import 'package:archive/archive.dart';

class CompressorService {
  String compress(String text) {
    final encoder = GZipEncoder();

    // Encode the compressed data with base64
    return base64.encode(encoder.encode(utf8.encode(text))!);
  }

  String decode(String base64Text) {
    final decoder = GZipDecoder();
    // Decode the encoded bytes from base64
    final decodedBytes = base64.decode(base64Text);

    // Decode the compressed bytes using gzip decompression
    return utf8.decode(decoder.decodeBytes(decodedBytes));
  }
}
