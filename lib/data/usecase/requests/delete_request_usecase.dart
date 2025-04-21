import 'package:dartz/dartz.dart';

import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class DeleteRequestUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  DeleteRequestUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, void>> call(
    final String params,
  ) async =>
      await _notificationRepository.deleteRequest(params);
}
