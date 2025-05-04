class RequestAlreadyAcceptedException implements Exception {
  final String message;

  RequestAlreadyAcceptedException([this.message = 'Request already accepted.']);

  @override
  String toString() => 'RequestAlreadyAcceptedException: $message';
}
