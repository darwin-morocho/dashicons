import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../domain/models/package.dart';

part 'package_state.freezed.dart';

@freezed
class PackageState with _$PackageState {
  factory PackageState({
    required Package package,
    @Default(true) bool changesPusblished,
    @Default(0) int tabIndex,
    @Default(false) bool updating,
    @Default(false) bool reorder,
  }) = _PackageState;
}
