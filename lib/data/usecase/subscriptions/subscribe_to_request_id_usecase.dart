import 'package:dartz/dartz.dart';

import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class SubscribeToRequestIdUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  SubscribeToRequestIdUsecase(this._notificationRepository);

  @override
  Future<Either> call(final String params) async =>
      await _notificationRepository.subscribeToRequestUpdates(params);
}
