import 'dart:async';

import 'package:flutter_meedu/notifiers.dart';
import 'package:flutter_meedu/providers.dart';

import '../../../../domain/models/package.dart';
import '../../../../domain/use_cases/packages/create_package.dart';
import '../../../../domain/use_cases/packages/get_user_packages.dart';
import '../../../../domain/use_cases/packages/listen_package.dart';
import '../../../../domain/use_cases/packages/update_package.dart';
import '../../../dependency_injection.dart';
import 'dashboard_state.dart';

final dashboardProvider = StateNotifierProvider<DashboardBloc, DashboardState>(
  (_) => DashboardBloc(
    const DashboardState.loading(),
    getUserPackagesUseCase: GetUserPackagesUseCase(Repositories.packages.read()),
    createPackageUseCase: CreatePackageUseCase(Repositories.packages.read()),
    listenPackageUseCase: ListenPackageUseCase(Repositories.packages.read()),
    updatePackageUseCase: UpdatePackageUseCase(Repositories.packages.read()),
  )..init(),
  autoDispose: false,
);

class DashboardBloc extends StateNotifier<DashboardState> {
  DashboardBloc(
    super.initialState, {
    required GetUserPackagesUseCase getUserPackagesUseCase,
    required CreatePackageUseCase createPackageUseCase,
    required ListenPackageUseCase listenPackageUseCase,
    required UpdatePackageUseCase updatePackageUseCase,
  })  : _getUserPackagesUseCase = getUserPackagesUseCase,
        _createPackageUseCase = createPackageUseCase,
        _listenPackageUseCase = listenPackageUseCase,
        _updatePackageUseCase = updatePackageUseCase;

  final GetUserPackagesUseCase _getUserPackagesUseCase;
  final CreatePackageUseCase _createPackageUseCase;
  final ListenPackageUseCase _listenPackageUseCase;
  final UpdatePackageUseCase _updatePackageUseCase;

  final _subscritions = <String, StreamSubscription>{};

  void _listenPackageChanges(Package package) {
    _subscritions[package.id] = _listenPackageUseCase(package.id).listen(
      (package) {
        state.mapOrNull(
          loaded: (state) {
            final packages = [...state.packages];
            final index = packages.indexWhere((e) => e.id == package.id);
            if (index != -1) {
              packages[index] = package;
              this.state = state.copyWith(packages: packages);
            }
          },
        );
      },
    );
  }

  Future<void> init() async {
    state.maybeMap(
      loading: (_) {},
      orElse: () => state = const DashboardState.loading(),
    );

    final packages = await _getUserPackagesUseCase();
    if (packages != null) {
      state = DashboardState.loaded(packages);
      for (final package in packages) {
        _listenPackageChanges(package);
      }
    } else {
      state = const DashboardState.failed();
    }
  }

  Future<Package?> createPackage(Package package) async {
    final createdpackage = await _createPackageUseCase(package);
    if (createdpackage != null) {
      state.mapOrNull(
        loaded: (state) {
          this.state = state.copyWith(
            packages: [...state.packages, createdpackage],
          );
        },
      );
      _listenPackageChanges(createdpackage);
    }
    return createdpackage;
  }

  Future<bool> updatePackage(Package package) {
    return _updatePackageUseCase(package);
  }

  @override
  FutureOr<void> dispose() {
    for (final subscription in _subscritions.values) {
      subscription.cancel();
    }
    return super.dispose();
  }
}
