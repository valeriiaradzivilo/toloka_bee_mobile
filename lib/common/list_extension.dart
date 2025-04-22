extension ListExtension<T> on List<T>? {
  List<T> get orEmpty => this ?? [];
}
