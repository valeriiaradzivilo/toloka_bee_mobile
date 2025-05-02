import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';
import '../../source/notifications/fcm_data_source.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FcmDataSource _fcmDataSource;
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
      await _fcmDataSource.sendNotification(notification);
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
        notifications
            .where(
              (final notification) =>
                  notification.userId != FirebaseAuth.instance.currentUser?.uid,
            )
            .toList(),
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
}
