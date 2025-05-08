import 'package:dartz/dartz.dart';

import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class CancelRequestUsecase extends UseCase<Either, CancelRequestUsecaseParams> {
  final NotificationRepository _notificationRepository;

  CancelRequestUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, void>> call(
    final CancelRequestUsecaseParams params,
  ) async =>
      await _notificationRepository.cancelRequest(params);
}

class CancelRequestUsecaseParams {
  final String requestId;
  final String reason;
  CancelRequestUsecaseParams({
    required this.requestId,
    required this.reason,
  });
}
