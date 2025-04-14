import 'package:dartz/dartz.dart';

import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Fail, String>> getFcmToken();
  Future<Either<Fail, void>> subscribeToTopic(
    final LocationSubscriptionModel locationSubscription,
  );

  Future<Either<Fail, void>> unsubscribeFromTopic(
    final LocationSubscriptionModel locationSubscription,
  );

  Future<Either<Fail, int>> countVolunteersByTopic(
    final String topic,
  );

  Future<Either<Fail, void>> createNotification(
    final RequestNotificationModel notification,
  );
  Future<Either<Fail, List<RequestNotificationModel>>> getAllRequests(
    final GetRequestsModel location,
  );
  Future<Either<Fail, void>> updateNotification(
    final RequestNotificationModel notification,
  );
}
