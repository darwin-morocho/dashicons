import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session({
    required String idToken,
    required String apiKey,
    required String refreshToken,
    required String expiresIn,
  }) = _Session;

  factory Session.fromJson(Json json) => _$SessionFromJson(json);
}
