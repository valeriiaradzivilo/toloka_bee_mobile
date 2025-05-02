import 'package:dartz/dartz.dart';

import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Fail, String>> getFcmToken();
  Future<Either<Fail, void>> subscribeToTopics(
    final List<LocationSubscriptionModel> locationSubscription,
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
  Future<Either<Fail, RequestNotificationModel>> getRequestById(
    final String id,
  );
  Future<Either<Fail, void>> updateRequest(
    final RequestNotificationModel notification,
  );
  Future<Either<Fail, void>> acceptRequest(
    final String id,
  );
  Future<Either<Fail, void>> deleteRequest(
    final String id,
  );
  Future<Either<Fail, List<RequestNotificationModel>>> getAllRequestsByUserId(
    final String userId,
  );
  Future<Either<Fail, List<RequestNotificationModel>>> getRequestsByIds(
    final List<String> ids,
  );
}
