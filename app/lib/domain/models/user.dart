import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required String id,
    required String fullName,
    required String email,
    String? avatar,
  }) = _User;

  factory User.fromJson(Json json) => _$UserFromJson(json);
}
