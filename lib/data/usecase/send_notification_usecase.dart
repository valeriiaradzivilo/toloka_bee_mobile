import 'package:dartz/dartz.dart';

import '../models/request_notification_model.dart';
import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class SendNotificationUsecase
    extends UseCase<Either, RequestNotificationModel> {
  final NotificationRepository _notificationRepository;

  SendNotificationUsecase(this._notificationRepository);

  @override
  Future<Either> call(final RequestNotificationModel params) async =>
      await _notificationRepository.createNotification(params);
}
