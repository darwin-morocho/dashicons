import 'package:freezed_annotation/freezed_annotation.dart';

part 'either.freezed.dart';

@freezed
class Either<L, R> with _$Either<L, R> {
  const Either._();
  const factory Either.left(L value) = _Left<L, R>;
  const factory Either.right(R value) = _Right<L, R>;

  T whenIsRight<T>(T Function(R value) callback) {
    return when(
      left: (_) => throw AssertionError('whenIsRight was called during a Left value'),
      right: callback,
    );
  }

  T whenIsLeft<T>(T Function(L value) callback) {
    return when(
      left: callback,
      right: (_) => throw AssertionError('whenIsLeft was called during a Right value'),
    );
  }
}
