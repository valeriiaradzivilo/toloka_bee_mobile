import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Fail, void>> subscribeToTopic(
    final LocationSubscriptionModel locationSubscription,
  ) async {
    try {
      if (_subscribedTopics.firstWhereOrNull(
            (final topic) => topic.id == locationSubscription.id,
          ) !=
          null) {
        return const Right(null);
      }

      if (_subscribedTopics.isNotEmpty) {
        final unsubscribeFrom = _subscribedTopics.last;
        await _fcmDataSource.unsubscribeFromTopic(unsubscribeFrom);
        _subscribedTopics.removeLast();
        logger.info('Unsubscribed from topic: $unsubscribeFrom');
      }
      await _fcmDataSource.subscribeToTopic(locationSubscription);
      _subscribedTopics.add(locationSubscription);
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

  final List<LocationSubscriptionModel> _subscribedTopics = [];

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> getAllRequests(
    final GetRequestsModel location,
  ) async {
    try {
      final notifications = await _fcmDataSource.getAllRequests(location);
      return Right(notifications);
    } catch (e) {
      logger.severe(
        '❌ Error while getting all requests: ${e.toString()}',
      );
      return Left(Fail('Failed to get all requests'));
    }
  }

  @override
  Future<Either<Fail, void>> updateNotification(
    final RequestNotificationModel notification,
  ) async {
    try {
      await _fcmDataSource.updateNotification(notification);
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
  Future<Either<Fail, void>> unsubscribeFromTopic(
    final LocationSubscriptionModel locationSubscription,
  ) {
    // TODO: implement unsubscribeFromTopic
    throw UnimplementedError();
  }
}
