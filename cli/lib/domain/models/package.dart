// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';
import 'svg_icon.dart';

part 'package.freezed.dart';
part 'package.g.dart';

@freezed
class Package with _$Package {
  factory Package({
    required String id,
    required String name,
    required String fontFamily,
    required String? fontPackage,
    required int lastId,
    @JsonKey(toJson: _iconsToJsonList) required List<SvgIcon> icons,
  }) = _Package;

  factory Package.fromJson(Json json) => _$PackageFromJson(json);
}

List<Map> _iconsToJsonList(List<SvgIcon> icons) {
  return icons.map((e) => e.toJson()).toList();
}
