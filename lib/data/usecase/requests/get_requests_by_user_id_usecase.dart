import 'package:dartz/dartz.dart';

import '../../models/request_notification_model.dart';
import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class GetRequestsByUserIdUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  GetRequestsByUserIdUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> call(
    final String userId,
  ) async =>
      _notificationRepository.getAllRequestsByUserId(userId);
}
