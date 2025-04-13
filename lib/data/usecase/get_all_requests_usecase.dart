import 'package:dartz/dartz.dart';

import '../models/get_requests_model.dart';
import '../repository/notifications/notification_repository.dart';
import 'usecase.dart';

class GetAllRequestsUsecase extends UseCase<Either, GetRequestsModel> {
  final NotificationRepository _notificationRepository;

  GetAllRequestsUsecase(this._notificationRepository);

  @override
  Future<Either> call(final GetRequestsModel params) async =>
      await _notificationRepository.getAllRequests(params);
}
