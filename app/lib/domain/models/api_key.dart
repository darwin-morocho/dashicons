import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'api_key.freezed.dart';
part 'api_key.g.dart';

@freezed
class ApiKey with _$ApiKey {
  factory ApiKey({
    required String id,
    required String uid,
    required String key,
    required DateTime createdAt,
  }) = _ApiKey;

  factory ApiKey.fromJson(Json json) => _$ApiKeyFromJson(json);
}
