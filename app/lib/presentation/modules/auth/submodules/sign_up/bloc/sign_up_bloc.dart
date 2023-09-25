import 'package:flutter_meedu/meedu.dart';

import '../../../../../../domain/failures/sign_up_failure.dart';
import '../../../../../../domain/models/user.dart';
import '../../../../../../domain/typedefs.dart';
import '../../../../../../domain/use_cases/auth/sign_up.dart';
import '../../../../../dependency_injection.dart';
import '../../../../../global/blocs/session/session_bloc.dart';
import 'sign_up_state.dart';

final signUpProvider = StateProvider<SignUpBloc, SignUpState>(
  (_) => SignUpBloc(
    const SignUpState(),
    signUpUseCase: SignUpUseCase(Repositories.auth),
    sessionBloc: sessionProvider.read,
  ),
);

class SignUpBloc extends StateNotifier<SignUpState> {
  SignUpBloc(
    super.initialState, {
    required SignUpUseCase signUpUseCase,
    required SessionBloc sessionBloc,
  })  : _sessionBloc = sessionBloc,
        _signUpUseCase = signUpUseCase;

  final SignUpUseCase _signUpUseCase;
  final SessionBloc _sessionBloc;

  void onEmailChanged(String email) {
    state = state.copyWith(email: email.trim());
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(password: password.trim());
  }

  void onFullNameChanged(String fullName) {
    state = state.copyWith(fullName: fullName.trim());
  }

  FutureEither<SignUpFailure, User> submit() async {
    state = state.copyWith(fetching: true);
    final result = await _signUpUseCase(
      email: state.email,
      password: state.password,
      fullName: state.fullName,
    );

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: _sessionBloc.setUser,
    );

    return result;
  }
}
