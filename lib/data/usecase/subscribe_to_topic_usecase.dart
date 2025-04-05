import 'package:dartz/dartz.dart';

import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class SubscribeToTopicUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  SubscribeToTopicUsecase(this._notificationRepository);

  @override
  Future<Either> call(final String params) async =>
      await _notificationRepository.subscribeToTopic(params);
}
