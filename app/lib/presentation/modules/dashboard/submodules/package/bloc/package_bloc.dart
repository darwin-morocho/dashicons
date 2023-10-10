import 'dart:async';

import 'package:flutter_meedu/notifiers.dart';
import 'package:flutter_meedu/providers.dart';

import '../../../../../../domain/models/package.dart';
import '../../../../../../domain/models/svg_icon.dart';
import '../../../../../../domain/use_cases/browser/update_url.dart';
import '../../../../../../domain/use_cases/packages/listen_package.dart';
import '../../../../../../domain/use_cases/packages/update_package.dart';
import '../../../../../dependency_injection.dart';
import '../../../../../router/router.dart';
import '../../../bloc/dashboard_bloc.dart';
import 'package_state.dart';

final packageProvider = StateNotifierArgumentsProvider<PackageBloc, PackageState, String>(
  (ref) => PackageBloc(
    PackageState(
      package: dashboardProvider.read().state.mapOrNull(
            loaded: (state) => state.packages.firstWhere(
              (e) => ref.arguments == e.id,
            ),
          )!,
    ),
    updatePackageUseCase: UpdatePackageUseCase(
      Repositories.packages.read(),
    ),
    listenPackageUseCase: ListenPackageUseCase(
      Repositories.packages.read(),
    ),
    updateBrowserUrlUseCase: UpdateBrowserUrlUseCase(
      Repositories.browserUtils.read(),
    ),
  ),
);

class PackageBloc extends StateNotifier<PackageState> {
  PackageBloc(
    super.initialState, {
    required UpdatePackageUseCase updatePackageUseCase,
    required ListenPackageUseCase listenPackageUseCase,
    required UpdateBrowserUrlUseCase updateBrowserUrlUseCase,
  })  : _updatePackageUseCase = updatePackageUseCase,
        _listenPackageUseCase = listenPackageUseCase,
        _updateBrowserUrlUseCase = updateBrowserUrlUseCase {
    _prevIcons = state.package.icons;
    init();
  }
  final UpdatePackageUseCase _updatePackageUseCase;
  final ListenPackageUseCase _listenPackageUseCase;
  final UpdateBrowserUrlUseCase _updateBrowserUrlUseCase;

  late List<SvgIcon> _prevIcons;
  List<SvgIcon> get savedIcons => _prevIcons;

  StreamSubscription? _subscription;

  Future<void> init() async {
    _subscription?.cancel();

    _subscription = _listenPackageUseCase(state.package.id).listen(
      (package) async {
        state = PackageState(
          package: package,
        );
      },
    );
  }

  void onPackageChanged(Package package) {
    _prevIcons = package.icons;
    state = PackageState(package: package);
    _updateBrowserUrlUseCase(
      package.name,
      PackageRoute.path.replaceFirst(':id', package.id),
    );
    init();
  }

  void onTabIndexChanged(int index) {
    state = state.copyWith(tabIndex: index);
  }

  Future<bool> onAddIcons(List<SvgIcon> newIcons) async {
    final package = state.package;

    return _updatePackageUseCase(
      package.copyWith(
        icons: [
          ...package.icons,
          ...newIcons,
        ],
      ),
    );
  }

  void onImport(List<SvgIcon> newIcons, bool override) {
    final package = state.package;
    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(
        icons: override
            ? newIcons
            : [
                ...package.icons,
                ...newIcons,
              ],
      ),
    );
  }

  void onToggleSelection(SvgIcon icon) {
    _setPrevIcons();
    final package = state.package;
    final icons = [...package.icons];
    final index = icons.indexOf(icon);
    icons[index] = icon.copyWith(
      selected: !icon.selected,
    );
    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(icons: icons),
    );
  }

  void onRemove(SvgIcon icon) {
    _setPrevIcons();
    final package = state.package;
    final icons = [...package.icons];
    icons.remove(icon);

    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(icons: icons),
    );
  }

  void onClearSelection() {
    _setPrevIcons();
    final package = state.package;
    final icons = [...package.icons].map(
      (e) => e.copyWith(selected: false),
    );

    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(icons: icons.toList()),
    );
  }

  void onSelectAll() {
    _setPrevIcons();
    final package = state.package;
    final icons = [...package.icons].map(
      (e) => e.copyWith(selected: true),
    );

    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(icons: icons.toList()),
    );
  }

  void onRemoveAll() {
    _setPrevIcons();
    final package = state.package;
    state = state.copyWith(
      changesPusblished: false,
      package: package.copyWith(
        icons: [],
      ),
    );
  }

  Future<bool> publishChanges() async {
    final updated = await _updatePackageUseCase(state.package);

    if (updated) {
      state = state.copyWith(changesPusblished: true, reorder: false);
      _setPrevIcons();
    }
    return updated;
  }

  void revertChanges() {
    state = state.copyWith(
      changesPusblished: true,
      reorder: false,
      package: state.package.copyWith(
        icons: _prevIcons,
      ),
    );
  }

  void toogleReorder() {
    state = state.copyWith(
      reorder: !state.reorder,
    );
  }

  void onChangeName(SvgIcon icon, String newName) {
    _setPrevIcons();
    final icons = [...state.package.icons];
    final index = icons.indexOf(icon);
    if (index == -1) {
      return;
    }
    icons[index] = icon.copyWith(name: newName);
    state = state.copyWith(
      changesPusblished: false,
      package: state.package.copyWith(
        icons: icons,
      ),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
    _setPrevIcons();
    final icons = [...state.package.icons];
    final element = icons.removeAt(oldIndex);
    icons.insert(newIndex, element);
    state = state.copyWith(
      changesPusblished: false,
      package: state.package.copyWith(
        icons: icons,
      ),
    );
  }

  void _setPrevIcons() {
    if (state.changesPusblished) {
      _prevIcons = state.package.icons;
    }
  }

  @override
  FutureOr<void> dispose() {
    _subscription?.cancel();
    return super.dispose();
  }
}
