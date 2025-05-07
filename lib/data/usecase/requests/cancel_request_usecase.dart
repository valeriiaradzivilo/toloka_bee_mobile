import 'package:dartz/dartz.dart';

import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class CancelRequestUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  CancelRequestUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, void>> call(
    final String params,
  ) async =>
      await _notificationRepository.cancelRequest(params);
}
