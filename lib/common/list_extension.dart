extension ListExtension<T> on List<T>? {
  List<T> get orEmpty => this ?? [];

  T? firstWhereOrNull(
    final bool Function(T element) test,
  ) {
    if (this == null) return null;
    for (final element in this!) {
      if (test(element)) return element;
    }
    return null;
  }
}
