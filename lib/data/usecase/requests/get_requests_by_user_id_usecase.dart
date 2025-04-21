import 'package:dartz/dartz.dart';

import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class GetRequestsByUserIdUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  GetRequestsByUserIdUsecase(this._notificationRepository);

  @override
  Future<Either> call(final String userId) async =>
      _notificationRepository.getAllRequestsByUserId(userId);
}
