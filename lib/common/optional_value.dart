abstract class Optional<T> {
  const Optional();

  T? get valueOrNull =>
      this is OptionalValue ? (this as OptionalValue).value : null;
}

class OptionalValue<T> extends Optional<T> {
  final T value;

  OptionalValue(this.value);
}

class OptionalNull<T> extends Optional<T> {
  const OptionalNull() : super();
}
