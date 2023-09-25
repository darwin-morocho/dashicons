import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/user.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    @Default(false) bool initialized,
    User? user,
  }) = _SessionState;
}
