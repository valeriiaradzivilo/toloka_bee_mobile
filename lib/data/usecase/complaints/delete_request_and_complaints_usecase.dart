import 'package:dartz/dartz.dart';

import '../../repository/complaints/complaint_repository.dart';
import '../../repository/notifications/notification_repository.dart';
import '../usecase.dart';

class DeleteRequestAndComplaintsUsecase
    extends UseCase<Either, DeleteRequestUsecaseParams> {
  final NotificationRepository _notificationRepository;
  final ComplaintRepository _complaintRepository;

  DeleteRequestAndComplaintsUsecase(
    this._notificationRepository,
    this._complaintRepository,
  );

  @override
  Future<Either<Fail, void>> call(
    final DeleteRequestUsecaseParams params,
  ) async {
    for (final complaintId in params.complaintId) {
      final result =
          await _complaintRepository.deleteRequestComplaint(complaintId);
      if (result.isLeft()) {
        return result;
      }
    }

    return await _notificationRepository.deleteRequest(params.requestId);
  }
}

class DeleteRequestUsecaseParams {
  final List<String> complaintId;
  final String requestId;

  DeleteRequestUsecaseParams({
    required this.complaintId,
    required this.requestId,
  });
}
