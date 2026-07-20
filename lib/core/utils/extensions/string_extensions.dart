extension NullableStringX on String? {
  /// `true` when the value is null, empty, or only whitespace.
  bool get isNullOrBlank {
    final value = this;
    return value == null || value.trim().isEmpty;
  }
}
