extension Cycle<T> on List<T> {
  T next(T current) {
    if (isEmpty) {
      throw StateError('List Cycle:Cannot get next item from an empty list.');
    }
    final i = indexOf(current);
    if (i == -1) {
      throw ArgumentError.value(
          current, 'current', 'List Cycle:Item not found in list.');
    }
    return this[(i + 1) % length];
  }

  T back(T current) {
    if (isEmpty) {
      throw StateError(
          'List Cycle:Cannot get previous item from an empty list.');
    }
    final i = indexOf(current);
    if (i == -1) {
      throw ArgumentError.value(
          current, 'current', 'List Cycle:Item not found in list.');
    }
    return this[(i - 1 + length) % length];
  }
}
