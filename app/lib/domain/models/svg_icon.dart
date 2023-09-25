import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xml/xml.dart';

import '../typedefs.dart';

part 'svg_icon.freezed.dart';
part 'svg_icon.g.dart';

@freezed
class SvgIcon with _$SvgIcon {
  const SvgIcon._();
  const factory SvgIcon({
    @JsonKey(readValue: _readId) required int id,
    required String name,
    @JsonKey(readValue: _readPath) required String path,
    @Default(false) bool selected,
  }) = _SvgIcon;

  factory SvgIcon.fromJson(Json json) => _$SvgIconFromJson(json);

  String get charCode => String.fromCharCode(0xe000 + id);
  String get hexCode => (0xe000 + id).toRadixString(16);
}

int _readId(Map<dynamic, dynamic> json, String key) {
  return json['unicode'] ?? json['id'];
}

String _readPath(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey('value')) {
    return _getPathFromSvgString(json['value']);
  }
  return json[key];
}

String _getPathFromSvgString(String svg) {
  final document = XmlDocument.parse(svg);
  final paths = document.findAllElements('path');
  return paths.first.getAttribute('d')!;
}
