part of '../router.dart';

class AccountSettingsRoute extends AppRoute {
  static const path = '/account-settings';

  static GoRoute get _read {
    return GoRoute(
      path: path,
      name: 'Account Settings',
      redirect: authMiddleware,
      builder: (_, __) => const AccountSettingsScreen(),
    );
  }

  @override
  String get location => path;
}
