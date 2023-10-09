import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meedu/providers.dart';
import 'package:go_router/go_router.dart';

import '../global/blocs/session/session_bloc.dart';
import '../global/widgets/main_scaffold/main_app_scaffold.dart';
import '../modules/account_settings/view/account_settings_screen.dart';
import '../modules/auth/view/auth_screen.dart';
import '../modules/dashboard/bloc/dashboard_bloc.dart';
import '../modules/dashboard/bloc/dashboard_state.dart';
import '../modules/dashboard/submodules/package/bloc/package_bloc.dart';
import '../modules/dashboard/submodules/package/view/package_view.dart';
import '../modules/dashboard/view/dashboard_screen.dart';
import '../modules/error/view/error_view.dart';
import '../modules/terms/view/terms_and_privacy_screen.dart';

part 'routes/account_settings.dart';
part 'routes/auth.dart';
part 'routes/dashboard.dart';
part 'routes/package.dart';
part 'routes/terms.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: sessionProvider.read().state.user != null
        ? DashboardRoute().location
        : AuthRoute().location,
    errorBuilder: (_, __) => const ErrorView(),
    routes: [
      AuthRoute._read,
      TermsAndPrivacyRoute._read,
      ShellRoute(
        pageBuilder: (_, state, navigator) => CustomTransitionPage(
          key: state.pageKey,
          child: MainAppScaffold(child: navigator),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        routes: [
          AccountSettingsRoute._read,
          DashboardRoute._read,
          PackageRoute._read,
        ],
      ),
    ],
  ),
);

FutureOr<String?> authMiddleware(BuildContext context, GoRouterState state) {
  if (sessionProvider.read().state.user != null) {
    return null;
  }
  return AuthRoute.path;
}

abstract class AppRoute {
  String get location;

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
