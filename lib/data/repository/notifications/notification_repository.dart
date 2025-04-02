import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<Fail, String>> getFcmToken();
  Future<Either<Fail, void>> subscribeToTopic(final String topic);
}
