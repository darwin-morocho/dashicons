// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@freezed
class Config with _$Config {
  factory Config({
    required String name,
    @JsonKey(name: 'css_prefix_text') @Default('') String cssPrefixText,
    @JsonKey(name: 'css_use_suffix') @Default(false) bool cssUseSuffix,
    @JsonKey(name: 'units_per_em') @Default(1000) int unitsPerEm,
    @Default(true) bool hinting,
    @Default(850) int ascent,
    @JsonKey(toJson: _glyphsToJsonList) required List<Glyph> glyphs,
  }) = _Config;

  factory Config.fromJson(Json json) => _$ConfigFromJson(json);
}

List<Map> _glyphsToJsonList(List<Glyph> glyphs) {
  return glyphs.map((e) => e.toJson()).toList();
}

@freezed
class Glyph with _$Glyph {
  factory Glyph({
    required String uid,
    required String css,
    required bool selected,
    required int code,
    required Json svg,
    @Default('custom_icons') String src,
    required List<String> search,
  }) = _Glyph;

  factory Glyph.fromJson(Json json) => _$GlyphFromJson(json);
}
