import 'package:dartz/dartz.dart';

import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class GetVolunteersByLocationUsecase extends UseCase<Either, String> {
  final NotificationRepository _notificationRepository;

  GetVolunteersByLocationUsecase(this._notificationRepository);

  @override
  Future<Either<Fail, int>> call(final String params) async =>
      await _notificationRepository.countVolunteersByTopic(params);
}
