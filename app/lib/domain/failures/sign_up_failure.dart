import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_failure.freezed.dart';

@freezed
class SignUpFailure with _$SignUpFailure {
  const factory SignUpFailure.duplicatedEmail() = _DuplicatedEmail;
  const factory SignUpFailure.network() = _Network;
  const factory SignUpFailure.tooManyRequests() = _TooManyRequests;
  const factory SignUpFailure.unhandledException() = _UnhandledException;
}
