import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/package.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.failed() = _Failed;
  const factory DashboardState.loaded(List<Package> packages) = DashboardLoadedState;
}
