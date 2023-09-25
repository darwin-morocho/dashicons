// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'svg_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SvgIcon _$SvgIconFromJson(Map<String, dynamic> json) {
  return _SvgIcon.fromJson(json);
}

/// @nodoc
mixin _$SvgIcon {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SvgIconCopyWith<SvgIcon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SvgIconCopyWith<$Res> {
  factory $SvgIconCopyWith(SvgIcon value, $Res Function(SvgIcon) then) =
      _$SvgIconCopyWithImpl<$Res, SvgIcon>;
  @useResult
  $Res call({int id, String name, String path, bool selected});
}

/// @nodoc
class _$SvgIconCopyWithImpl<$Res, $Val extends SvgIcon>
    implements $SvgIconCopyWith<$Res> {
  _$SvgIconCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SvgIconCopyWith<$Res> implements $SvgIconCopyWith<$Res> {
  factory _$$_SvgIconCopyWith(
          _$_SvgIcon value, $Res Function(_$_SvgIcon) then) =
      __$$_SvgIconCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String path, bool selected});
}

/// @nodoc
class __$$_SvgIconCopyWithImpl<$Res>
    extends _$SvgIconCopyWithImpl<$Res, _$_SvgIcon>
    implements _$$_SvgIconCopyWith<$Res> {
  __$$_SvgIconCopyWithImpl(_$_SvgIcon _value, $Res Function(_$_SvgIcon) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? selected = null,
  }) {
    return _then(_$_SvgIcon(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SvgIcon extends _SvgIcon {
  const _$_SvgIcon(
      {required this.id,
      required this.name,
      required this.path,
      this.selected = false})
      : super._();

  factory _$_SvgIcon.fromJson(Map<String, dynamic> json) =>
      _$$_SvgIconFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String path;
  @override
  @JsonKey()
  final bool selected;

  @override
  String toString() {
    return 'SvgIcon(id: $id, name: $name, path: $path, selected: $selected)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SvgIcon &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, path, selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SvgIconCopyWith<_$_SvgIcon> get copyWith =>
      __$$_SvgIconCopyWithImpl<_$_SvgIcon>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SvgIconToJson(
      this,
    );
  }
}

abstract class _SvgIcon extends SvgIcon {
  const factory _SvgIcon(
      {required final int id,
      required final String name,
      required final String path,
      final bool selected}) = _$_SvgIcon;
  const _SvgIcon._() : super._();

  factory _SvgIcon.fromJson(Map<String, dynamic> json) = _$_SvgIcon.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get path;
  @override
  bool get selected;
  @override
  @JsonKey(ignore: true)
  _$$_SvgIconCopyWith<_$_SvgIcon> get copyWith =>
      throw _privateConstructorUsedError;
}
