// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'svg_icon.freezed.dart';
part 'svg_icon.g.dart';

@freezed
class SvgIcon with _$SvgIcon {
  const SvgIcon._();
  const factory SvgIcon({
    required int id,
    required String name,
    required String path,
    @Default(false) bool selected,
  }) = _SvgIcon;

  factory SvgIcon.fromJson(Json json) => _$SvgIconFromJson(json);

  String get charCode => String.fromCharCode(0xe000 + id);
  String get hexCode => (0xe000 + id).toRadixString(16);
}
