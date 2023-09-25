import 'dart:math';

import 'package:flutter/foundation.dart';
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
    @JsonKey(readValue: _readLastId) required int lastId,
    @JsonKey(toJson: _iconsToJsonList) required List<SvgIcon> icons,
  }) = _Package;

  factory Package.fromJson(Json json) => _$PackageFromJson(json);
}

List<Map> _iconsToJsonList(List<SvgIcon> icons) {
  return icons.map((e) => e.toJson()).toList();
}

int _readLastId(Map json, String key) {
  if (json.containsKey(key)) {
    return json[key];
  }
  final list = json['icons'] as List;
  if (list.isEmpty) {
    return 1;
  }
  return list.map((e) => e['id'] as int).reduce(max);
}
