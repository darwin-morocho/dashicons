import 'package:flutter_meedu/meedu.dart';

import '../../../../../../domain/failures/sign_in_failure.dart';
import '../../../../../../domain/failures/sign_up_failure.dart';
import '../../../../../../domain/models/user.dart';
import '../../../../../../domain/typedefs.dart';
import '../../../../../../domain/use_cases/auth/sign_in.dart';
import '../../../../../../domain/use_cases/auth/sign_in_eith_google.dart';
import '../../../../../dependency_injection.dart';
import '../../../../../global/blocs/session/session_bloc.dart';
import 'sign_in_state.dart';

final signInProvider = StateProvider<SignInBloc, SignInState>(
  (_) => SignInBloc(
    const SignInState(),
    sessionBloc: sessionProvider.read,
    signInUseCase: SignInUseCase(Repositories.auth),
    signInWithGoogleUseCase: SignInWithGoogleUseCase(Repositories.auth),
  ),
);

class SignInBloc extends StateNotifier<SignInState> {
  SignInBloc(
    super.initialState, {
    required SignInUseCase signInUseCase,
    required SessionBloc sessionBloc,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  })  : _sessionBloc = sessionBloc,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signInUseCase = signInUseCase;

  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SessionBloc _sessionBloc;

  void onEmailChanged(String email) {
    state = state.copyWith(email: email.trim());
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(password: password.trim());
  }

  FutureEither<SignInFailure, User> submit() async {
    state = state.copyWith(fetching: true);
    final result = await _signInUseCase(
      email: state.email,
      password: state.password,
    );

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: _sessionBloc.setUser,
    );

    return result;
  }

  FutureEither<SignUpFailure, User> signInWithGoogle() async {
    state = state.copyWith(fetching: true);
    final result = await _signInWithGoogleUseCase();
    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: _sessionBloc.setUser,
    );

    return result;
  }
}
