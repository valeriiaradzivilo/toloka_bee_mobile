import 'package:dartz/dartz.dart';

import '../../models/request_notification_model.dart';
import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class UpdateRequestUsecase extends UseCase<Either, RequestNotificationModel> {
  final NotificationRepository _notificationRepository;

  UpdateRequestUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, void>> call(
    final RequestNotificationModel params,
  ) async =>
      await _notificationRepository.updateRequest(params);
}
