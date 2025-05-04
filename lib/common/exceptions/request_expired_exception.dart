class RequestExpiredException implements Exception {
  final String? message;

  RequestExpiredException({this.message});

  @override
  String toString() => 'RequestExpiredException: $message';
}
