import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'font_cache.freezed.dart';
part 'font_cache.g.dart';

@freezed
class FontCache with _$FontCache {
  factory FontCache({
    required String packageId,
    required String base64Ttf,
    required int lastId,
  }) = _FontCache;

  factory FontCache.fromJson(Json json) => _$FontCacheFromJson(json);
}
