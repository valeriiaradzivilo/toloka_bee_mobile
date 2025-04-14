import 'package:dartz/dartz.dart';

import '../models/location_subscription_model.dart';
import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class SubscribeToTopicUsecase
    extends UseCase<Either, LocationSubscriptionModel> {
  final NotificationRepository _notificationRepository;

  SubscribeToTopicUsecase(this._notificationRepository);

  @override
  Future<Either> call(final LocationSubscriptionModel params) async =>
      await _notificationRepository.subscribeToTopic(params);
}
