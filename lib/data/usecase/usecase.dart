abstract class UseCase<Type, Params> {
  Future<Type> call(final Params params);
}
