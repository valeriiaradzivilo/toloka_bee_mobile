import 'package:dartz/dartz.dart';

import '../../models/request_notification_model.dart';
import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class GetRequestsByIdsUsecase extends UseCase<
    Either<Fail, List<RequestNotificationModel>>, List<String>> {
  GetRequestsByIdsUsecase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Fail, List<RequestNotificationModel>>> call(
    final List<String> ids,
  ) async =>
      await _repository.getRequestsByIds(ids);
}
