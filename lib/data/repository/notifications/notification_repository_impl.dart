import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

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
  Future<Either<Fail, void>> subscribeToTopic(final String topic) async {
    try {
      if (_subscribedTopics.contains(topic)) {
        return const Right(null);
      }

      if (_subscribedTopics.isNotEmpty) {
        final unsubscribeFrom = _subscribedTopics.last;
        await _fcmDataSource.unsubscribeFromTopic(unsubscribeFrom);
        _subscribedTopics.removeLast();
        logger.info('Unsubscribed from topic: $unsubscribeFrom');
      }
      await _fcmDataSource.subscribeToTopic(topic);
      _subscribedTopics.add(topic);
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

  final List<String> _subscribedTopics = [];
}
