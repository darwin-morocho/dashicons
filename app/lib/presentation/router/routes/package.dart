part of '../router.dart';

class PackageRoute extends AppRoute {
  PackageRoute({required this.id});
  final String id;

  static const path = '/package/:id';

  static GoRoute get _read {
    return GoRoute(
      path: path,
      name: 'Package details',
      redirect: _redirect,
      builder: (_, __) => const PackageScreen(),
    );
  }

  @override
  String get location => '/package/${Uri.encodeComponent(id)}';
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final redirect = await authMiddleware(context, state);
  if (redirect != null) {
    return redirect;
  }

  final id = state.pathParameters['id'];

  if (id is! String || id.isEmpty) {
    return DashboardRoute.path;
  }

  DashboardLoadedState? loadedState;
  if (!dashboardProvider.mounted()) {
    final completer = Completer();
    final bloc = dashboardProvider.read();
    late final void Function(DashboardState) listener;
    listener = (state) {
      bloc.removeListener(listener);
      state.mapOrNull(
        loaded: (state) => loadedState = state,
      );
      completer.complete();
    };
    bloc.addListener(listener);
    await completer.future;
  } else {
    dashboardProvider.read().state.mapOrNull(
      loaded: (state) {
        state.mapOrNull(
          loaded: (state) => loadedState = state,
        );
      },
    );
  }

  final packages = loadedState?.packages ?? [];

  final index = packages.indexWhere((e) => e.id == id);

  if (index == -1) {
    return DashboardRoute.path;
  }

  packageProvider.setArguments(id);
  return null;
}
