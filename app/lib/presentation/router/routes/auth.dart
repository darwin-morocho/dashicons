part of '../router.dart';

class AuthRoute extends AppRoute {
  static const path = '/auth';

  @override
  String get location => path;

  static GoRoute get _read {
    return GoRoute(
      path: path,
      redirect: (_, __) {
        if (sessionProvider.read.state.user != null) {
          return DashboardRoute.path;
        }
        return null;
      },
      builder: (_, __) => const AuthScreen(),
    );
  }
}
