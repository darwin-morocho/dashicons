// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get fontFamily => throw _privateConstructorUsedError;
  String? get fontPackage => throw _privateConstructorUsedError;
  int get lastId => throw _privateConstructorUsedError;
  @JsonKey(toJson: _iconsToJsonList)
  List<SvgIcon> get icons => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call(
      {String id,
      String name,
      String fontFamily,
      String? fontPackage,
      int lastId,
      @JsonKey(toJson: _iconsToJsonList) List<SvgIcon> icons});
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fontFamily = null,
    Object? fontPackage = freezed,
    Object? lastId = null,
    Object? icons = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      fontPackage: freezed == fontPackage
          ? _value.fontPackage
          : fontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastId: null == lastId
          ? _value.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as int,
      icons: null == icons
          ? _value.icons
          : icons // ignore: cast_nullable_to_non_nullable
              as List<SvgIcon>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
          _$PackageImpl value, $Res Function(_$PackageImpl) then) =
      __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String fontFamily,
      String? fontPackage,
      int lastId,
      @JsonKey(toJson: _iconsToJsonList) List<SvgIcon> icons});
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
      _$PackageImpl _value, $Res Function(_$PackageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fontFamily = null,
    Object? fontPackage = freezed,
    Object? lastId = null,
    Object? icons = null,
  }) {
    return _then(_$PackageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      fontPackage: freezed == fontPackage
          ? _value.fontPackage
          : fontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastId: null == lastId
          ? _value.lastId
          : lastId // ignore: cast_nullable_to_non_nullable
              as int,
      icons: null == icons
          ? _value._icons
          : icons // ignore: cast_nullable_to_non_nullable
              as List<SvgIcon>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageImpl implements _Package {
  _$PackageImpl(
      {required this.id,
      required this.name,
      required this.fontFamily,
      required this.fontPackage,
      required this.lastId,
      @JsonKey(toJson: _iconsToJsonList) required final List<SvgIcon> icons})
      : _icons = icons;

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String fontFamily;
  @override
  final String? fontPackage;
  @override
  final int lastId;
  final List<SvgIcon> _icons;
  @override
  @JsonKey(toJson: _iconsToJsonList)
  List<SvgIcon> get icons {
    if (_icons is EqualUnmodifiableListView) return _icons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_icons);
  }

  @override
  String toString() {
    return 'Package(id: $id, name: $name, fontFamily: $fontFamily, fontPackage: $fontPackage, lastId: $lastId, icons: $icons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.fontPackage, fontPackage) ||
                other.fontPackage == fontPackage) &&
            (identical(other.lastId, lastId) || other.lastId == lastId) &&
            const DeepCollectionEquality().equals(other._icons, _icons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, fontFamily,
      fontPackage, lastId, const DeepCollectionEquality().hash(_icons));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(
      this,
    );
  }
}

abstract class _Package implements Package {
  factory _Package(
      {required final String id,
      required final String name,
      required final String fontFamily,
      required final String? fontPackage,
      required final int lastId,
      @JsonKey(toJson: _iconsToJsonList)
      required final List<SvgIcon> icons}) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get fontFamily;
  @override
  String? get fontPackage;
  @override
  int get lastId;
  @override
  @JsonKey(toJson: _iconsToJsonList)
  List<SvgIcon> get icons;
  @override
  @JsonKey(ignore: true)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
