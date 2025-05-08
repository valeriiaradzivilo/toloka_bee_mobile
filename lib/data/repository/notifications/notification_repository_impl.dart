import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../../common/constants/request_constants.dart';
import '../../../common/exceptions/request_limit_reached_for_today.dart';
import '../../models/e_request_update.dart';
import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';
import '../../source/notifications/notifications_data_source.dart';
import '../../usecase/requests/cancel_request_usecase.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsDataSource _fcmDataSource;

  final logger = SimpleLogger();

  NotificationRepositoryImpl(this._fcmDataSource);

  @override
  Future<Either<Fail, String>> getFcmToken() async {
    try {
      final token = await _fcmDataSource.getFcmToken();
      if (token.isEmpty) {
        return Left(Fail('FCM token is empty'));
      }
      return Right(token);
    } catch (e) {
      return Left(Fail('Failed to get FCM token'));
    }
  }

  @override
  Future<Either<Fail, void>> subscribeToTopics(
    final List<LocationSubscriptionModel> locationSubscription,
  ) async {
    try {
      final Map<String, LocationSubscriptionModel> locationToSubscribe = {
        for (final location in locationSubscription) location.topic: location,
      };

      for (final subscription in _subscribedTopics.entries) {
        if (locationToSubscribe[subscription.key] == null) {
          await _fcmDataSource.unsubscribeFromTopic(subscription.value);
          _subscribedTopics.remove(subscription.key);
          logger.info('Unsubscribed from topic: ${subscription.key}');
        } else {
          locationToSubscribe.remove(subscription.key);
        }
      }

      for (final subscription in locationToSubscribe.entries) {
        await _fcmDataSource.subscribeToTopic(subscription.value);
        _subscribedTopics[subscription.key] = subscription.value;
        logger.info('Subscribed to topic: ${subscription.key}');
      }

      return const Right(null);
    } catch (e) {
      return Left(Fail('Failed to subscribe to topic'));
    }
  }

  @override
  Future<Either<Fail, void>> createNotification(
    final RequestNotificationModel notification,
  ) async {
    try {
      if (await _fcmDataSource
              .getCountOfTodayRequestsByUserId(notification.userId) >=
          RequestConstants.requestLimitForTheDay) {
        return Left(Fail(RequestLimitReachedForToday()));
      }
      await _fcmDataSource.sendNotification(notification);
      await _fcmDataSource.subscribeToRequestUpdates(notification.id);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while sending notification: ${e.toString()}',
      );
      return Left(Fail('Failed to send notification'));
    }
  }

  final Map<String, LocationSubscriptionModel> _subscribedTopics = {};

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> getAllRequests(
    final GetRequestsModel location,
  ) async {
    try {
      final notifications = await _fcmDataSource.getAllRequests(location);
      return Right(
        notifications,
      );
    } catch (e) {
      logger.severe(
        '❌ Error while getting all requests: ${e.toString()}',
      );
      return Left(Fail('Failed to get all requests'));
    }
  }

  @override
  Future<Either<Fail, void>> updateRequest(
    final RequestNotificationModel notification,
  ) async {
    try {
      await _fcmDataSource.updateRequest(notification);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while updating notification: ${e.toString()}',
      );
      return Left(Fail('Failed to update notification'));
    }
  }

  @override
  Future<Either<Fail, int>> countVolunteersByTopic(final String topic) async {
    try {
      final value = await _fcmDataSource.countVolunteersByTopic(topic);
      return Right(value);
    } catch (e) {
      logger.severe(
        '❌ Error while counting volunteers by topic: ${e.toString()}',
      );
      return Left(Fail('Failed to count volunteers by topic'));
    }
  }

  @override
  Future<Either<Fail, RequestNotificationModel>> getRequestById(
    final String id,
  ) async {
    try {
      final notification = await _fcmDataSource.getRequestById(id);
      return Right(notification);
    } catch (e) {
      logger.severe(
        '❌ Error while getting request by id: ${e.toString()}',
      );
      return Left(Fail('Failed to get request by id'));
    }
  }

  @override
  Future<Either<Fail, void>> acceptRequest(final String id) async {
    try {
      await _fcmDataSource.acceptRequest(id);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while accepting request: ${e.toString()}',
      );
      return Left(Fail('Failed to accept request'));
    }
  }

  @override
  Future<Either<Fail, void>> deleteRequest(final String id) async {
    try {
      await _fcmDataSource.deleteRequest(id);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while deleting request: ${e.toString()}',
      );
      return Left(Fail('Failed to delete request'));
    }
  }

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> getAllRequestsByUserId(
    final String userId,
  ) async {
    try {
      final notifications = await _fcmDataSource.getAllRequestsByUserId(userId);
      return Right(notifications);
    } catch (e) {
      logger.severe(
        '❌ Error while getting all requests by user id: ${e.toString()}',
      );
      return Left(Fail('Failed to get all requests by user id'));
    }
  }

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> getRequestsByIds(
    final List<String> ids,
  ) async {
    try {
      final notifications = await _fcmDataSource.getRequestsByIds(ids);
      return Right(notifications);
    } catch (e) {
      logger.severe(
        '❌ Error while getting requests by ids: ${e.toString()}',
      );
      return Left(Fail('Failed to get requests by ids'));
    }
  }

  @override
  Future<Either<Fail, void>> subscribeToRequestUpdates(
    final String requestId,
  ) async {
    try {
      await _fcmDataSource.subscribeToRequestUpdates(requestId);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while subscribing to request updates: ${e.toString()}',
      );
      return Left(Fail('Failed to subscribe to request updates'));
    }
  }

  @override
  Future<Either<Fail, void>> unsubscribeFromRequestUpdates(
    final String requestId,
  ) async {
    try {
      await _fcmDataSource.unsubscribeFromRequestUpdates(requestId);
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while unsubscribing from request updates: ${e.toString()}',
      );
      return Left(Fail('Failed to unsubscribe from request updates'));
    }
  }

  @override
  Future<Either<Fail, void>> cancelRequest(
    final CancelRequestUsecaseParams params,
  ) async {
    try {
      await _fcmDataSource.cancelRequest(params.requestId);

      await _fcmDataSource.unsubscribeFromRequestUpdates(params.requestId);
      await _fcmDataSource.sendRequestUpdateNotification(
        params.requestId,
        ERequestUpdate.canceledByRequester,
        additionalData: params.reason,
      );
      return const Right(null);
    } catch (e) {
      logger.severe(
        '❌ Error while canceling request: ${e.toString()}',
      );
      return Left(Fail('Failed to cancel request'));
    }
  }
}
