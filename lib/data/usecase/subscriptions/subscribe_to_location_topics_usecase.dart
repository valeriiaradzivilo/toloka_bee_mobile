import 'package:dartz/dartz.dart';

import '../../models/location_subscription_model.dart';
import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class SubscribeToLocationTopicsUsecase
    extends UseCase<Either, List<LocationSubscriptionModel>> {
  final NotificationRepository _notificationRepository;

  SubscribeToLocationTopicsUsecase(this._notificationRepository);

  @override
  Future<Either> call(final List<LocationSubscriptionModel> params) async =>
      await _notificationRepository.subscribeToTopics(params);
}
