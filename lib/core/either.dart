sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) =>
      switch (this) {
        Left<L, R>(:final value) => onLeft(value),
        Right<L, R>(:final value) => onRight(value),
      };

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  bool operator ==(Object other) => other is Left && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  bool operator ==(Object other) => other is Right && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
