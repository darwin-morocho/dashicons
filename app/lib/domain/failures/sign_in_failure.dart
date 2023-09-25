import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_failure.freezed.dart';

@freezed
class SignInFailure with _$SignInFailure {
  const factory SignInFailure.userNotFound() = _UserNotFound;
  const factory SignInFailure.invalidPassword() = _InvalidPassword;
  const factory SignInFailure.disabled() = _Disabled;
  const factory SignInFailure.network() = _Network;
  const factory SignInFailure.tooManyRequests() = _TooManyRequests;
  const factory SignInFailure.unhandledException() = _UnhandledExceptio;
}
