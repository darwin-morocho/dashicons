part of '../router.dart';

class DashboardRoute extends AppRoute {
  static const path = '/dashboard';

  @override
  String get location => path;

  static GoRoute get _read {
    return GoRoute(
      path: path,
      name: 'Dashboard',
      redirect: authMiddleware,
      builder: (_, __) => const DashboardScreen(),
    );
  }
}
