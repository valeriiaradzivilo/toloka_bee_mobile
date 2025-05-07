import '../../models/e_request_update.dart';
import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';

abstract class FcmDataSource {
  Future<String> getFcmToken();

  Future<void> subscribeToTopic(
    final LocationSubscriptionModel locationSubscription,
  );

  Future<void> unsubscribeFromTopic(
    final LocationSubscriptionModel locationSubscription,
  );

  Future<void> sendNotification(final RequestNotificationModel notification);

  Future<List<RequestNotificationModel>> getAllRequests(
    final GetRequestsModel location,
  );

  Future<int> countVolunteersByTopic(final String topic);

  Future<RequestNotificationModel> getRequestById(final String id);

  Future<void> acceptRequest(final String id);

  Future<void> updateRequest(final RequestNotificationModel notification);

  Future<void> deleteRequest(final String id);

  Future<List<RequestNotificationModel>> getAllRequestsByUserId(
    final String userId,
  );

  Future<List<RequestNotificationModel>> getRequestsByIds(
    final List<String> ids,
  );
  Future<void> subscribeToRequestUpdates(final String requestId);
  Future<void> unsubscribeFromRequestUpdates(final String requestId);
  Future<void> sendRequestUpdateNotification(
    final String requestId,
    final ERequestUpdate requestUpdate,
  );

  Future<int> getCountOfTodayRequestsByUserId(final String userId);
  Future<void> cancelRequest(final String id);
}
