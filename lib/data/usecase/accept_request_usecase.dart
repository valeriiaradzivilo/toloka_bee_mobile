import 'package:dartz/dartz.dart';

import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class AcceptRequestUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  AcceptRequestUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, void>> call(
    final String params,
  ) async =>
      await _notificationRepository.acceptRequest(params);
}
