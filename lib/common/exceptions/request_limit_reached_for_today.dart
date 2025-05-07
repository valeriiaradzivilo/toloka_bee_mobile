import '../constants/request_constants.dart';

class RequestLimitReachedForToday implements Exception {
  RequestLimitReachedForToday();

  @override
  String toString() =>
      'RequestLimitReachedForToday: You have reached the limit of ${RequestConstants.requestLimitForTheDay} requests for today. Please try again tomorrow.';
}
