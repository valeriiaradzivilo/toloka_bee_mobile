import 'package:dartz/dartz.dart';

import '../../models/request_notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Fail, String>> getFcmToken();
  Future<Either<Fail, void>> subscribeToTopic(final String topic);
  Future<Either<Fail, void>> createNotification(
    final RequestNotificationModel notification,
  );
}
