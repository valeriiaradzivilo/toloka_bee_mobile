sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

sealed class Error<T> extends Result<T> {
  final String message;
  Error(this.message);
}

class ErrorTimeout<T> extends Error<T> {
  ErrorTimeout(super.message);
}

class ErrorNetwork<T> extends Error<T> {
  ErrorNetwork(super.message);
}

class ErrorUnknown<T> extends Error<T> {
  ErrorUnknown(super.message);
}
