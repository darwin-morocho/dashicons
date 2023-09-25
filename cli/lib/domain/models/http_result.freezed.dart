// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HttpResult<T> {
  int? get statusCode => throw _privateConstructorUsedError;
  Object? get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, T data) success,
    required TResult Function(int? statusCode, Object? data) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, T data)? success,
    TResult? Function(int? statusCode, Object? data)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, T data)? success,
    TResult Function(int? statusCode, Object? data)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HttpSuccess<T> value) success,
    required TResult Function(_HttpFailed<T> value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HttpSuccess<T> value)? success,
    TResult? Function(_HttpFailed<T> value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HttpSuccess<T> value)? success,
    TResult Function(_HttpFailed<T> value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HttpResultCopyWith<T, HttpResult<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpResultCopyWith<T, $Res> {
  factory $HttpResultCopyWith(
          HttpResult<T> value, $Res Function(HttpResult<T>) then) =
      _$HttpResultCopyWithImpl<T, $Res, HttpResult<T>>;
  @useResult
  $Res call({int statusCode});
}

/// @nodoc
class _$HttpResultCopyWithImpl<T, $Res, $Val extends HttpResult<T>>
    implements $HttpResultCopyWith<T, $Res> {
  _$HttpResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode!
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HttpSuccessCopyWith<T, $Res>
    implements $HttpResultCopyWith<T, $Res> {
  factory _$$_HttpSuccessCopyWith(
          _$_HttpSuccess<T> value, $Res Function(_$_HttpSuccess<T>) then) =
      __$$_HttpSuccessCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({int statusCode, T data});
}

/// @nodoc
class __$$_HttpSuccessCopyWithImpl<T, $Res>
    extends _$HttpResultCopyWithImpl<T, $Res, _$_HttpSuccess<T>>
    implements _$$_HttpSuccessCopyWith<T, $Res> {
  __$$_HttpSuccessCopyWithImpl(
      _$_HttpSuccess<T> _value, $Res Function(_$_HttpSuccess<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? data = freezed,
  }) {
    return _then(_$_HttpSuccess<T>(
      null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_HttpSuccess<T> implements _HttpSuccess<T> {
  _$_HttpSuccess(this.statusCode, this.data);

  @override
  final int statusCode;
  @override
  final T data;

  @override
  String toString() {
    return 'HttpResult<$T>.success(statusCode: $statusCode, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HttpSuccess<T> &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, statusCode, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HttpSuccessCopyWith<T, _$_HttpSuccess<T>> get copyWith =>
      __$$_HttpSuccessCopyWithImpl<T, _$_HttpSuccess<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, T data) success,
    required TResult Function(int? statusCode, Object? data) failed,
  }) {
    return success(statusCode, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, T data)? success,
    TResult? Function(int? statusCode, Object? data)? failed,
  }) {
    return success?.call(statusCode, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, T data)? success,
    TResult Function(int? statusCode, Object? data)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(statusCode, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HttpSuccess<T> value) success,
    required TResult Function(_HttpFailed<T> value) failed,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HttpSuccess<T> value)? success,
    TResult? Function(_HttpFailed<T> value)? failed,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HttpSuccess<T> value)? success,
    TResult Function(_HttpFailed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _HttpSuccess<T> implements HttpResult<T> {
  factory _HttpSuccess(final int statusCode, final T data) = _$_HttpSuccess<T>;

  @override
  int get statusCode;
  @override
  T get data;
  @override
  @JsonKey(ignore: true)
  _$$_HttpSuccessCopyWith<T, _$_HttpSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_HttpFailedCopyWith<T, $Res>
    implements $HttpResultCopyWith<T, $Res> {
  factory _$$_HttpFailedCopyWith(
          _$_HttpFailed<T> value, $Res Function(_$_HttpFailed<T>) then) =
      __$$_HttpFailedCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({int? statusCode, Object? data});
}

/// @nodoc
class __$$_HttpFailedCopyWithImpl<T, $Res>
    extends _$HttpResultCopyWithImpl<T, $Res, _$_HttpFailed<T>>
    implements _$$_HttpFailedCopyWith<T, $Res> {
  __$$_HttpFailedCopyWithImpl(
      _$_HttpFailed<T> _value, $Res Function(_$_HttpFailed<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? data = freezed,
  }) {
    return _then(_$_HttpFailed<T>(
      freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == data ? _value.data : data,
    ));
  }
}

/// @nodoc

class _$_HttpFailed<T> implements _HttpFailed<T> {
  _$_HttpFailed(this.statusCode, this.data);

  @override
  final int? statusCode;
  @override
  final Object? data;

  @override
  String toString() {
    return 'HttpResult<$T>.failed(statusCode: $statusCode, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HttpFailed<T> &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, statusCode, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HttpFailedCopyWith<T, _$_HttpFailed<T>> get copyWith =>
      __$$_HttpFailedCopyWithImpl<T, _$_HttpFailed<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int statusCode, T data) success,
    required TResult Function(int? statusCode, Object? data) failed,
  }) {
    return failed(statusCode, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int statusCode, T data)? success,
    TResult? Function(int? statusCode, Object? data)? failed,
  }) {
    return failed?.call(statusCode, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int statusCode, T data)? success,
    TResult Function(int? statusCode, Object? data)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(statusCode, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HttpSuccess<T> value) success,
    required TResult Function(_HttpFailed<T> value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_HttpSuccess<T> value)? success,
    TResult? Function(_HttpFailed<T> value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HttpSuccess<T> value)? success,
    TResult Function(_HttpFailed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _HttpFailed<T> implements HttpResult<T> {
  factory _HttpFailed(final int? statusCode, final Object? data) =
      _$_HttpFailed<T>;

  @override
  int? get statusCode;
  @override
  Object? get data;
  @override
  @JsonKey(ignore: true)
  _$$_HttpFailedCopyWith<T, _$_HttpFailed<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
