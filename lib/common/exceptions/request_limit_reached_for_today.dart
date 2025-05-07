class RequestLimitReachedForToday implements Exception {
  RequestLimitReachedForToday();

  @override
  String toString() =>
      'RequestLimitReachedForToday: You have reached the limit of 5 requests for today. Please try again tomorrow.';
}
