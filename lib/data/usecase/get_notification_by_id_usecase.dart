import 'package:dartz/dartz.dart';

import '../models/request_notification_model.dart';
import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class GetNotificationByIdUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  GetNotificationByIdUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, RequestNotificationModel>> call(
    final String params,
  ) async =>
      await _notificationRepository.getRequestById(params);
}
