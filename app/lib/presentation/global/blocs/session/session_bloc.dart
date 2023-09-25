import 'package:flutter_meedu/meedu.dart';

import '../../../../domain/models/user.dart';
import '../../../../domain/use_cases/auth/get_authenticated_user.dart';
import '../../../../domain/use_cases/auth/sign_out.dart';
import '../../../dependency_injection.dart';
import 'session_state.dart';

final sessionProvider = StateProvider<SessionBloc, SessionState>(
  (_) => SessionBloc(
    const SessionState(),
    getAuthenticatedUserUseCase: GetAuthenticatedUserUseCase(Repositories.auth),
    signOutUseCase: SignOutUseCase(Repositories.auth),
  )..init(),
);

class SessionBloc extends StateNotifier<SessionState> {
  SessionBloc(
    super.initialState, {
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _signOutUseCase = signOutUseCase,
        _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase;

  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> init() async {
    final user = await _getAuthenticatedUserUseCase();
    state = state.copyWith(initialized: true, user: user);
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    state = state.copyWith(user: null);
  }
}
