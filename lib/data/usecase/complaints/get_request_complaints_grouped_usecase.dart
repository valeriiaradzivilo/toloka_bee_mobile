import 'package:dartz/dartz.dart';

import '../../models/request_complaints_group_model.dart';
import '../../repository/complaints/complaint_repository.dart';

class GetRequestComplaintsGroupedUsecase {
  final ComplaintRepository _repository;

  GetRequestComplaintsGroupedUsecase(this._repository);

  Future<Either<Fail, List<RequestComplaintsGroupModel>>> call(
    final String adminUserId,
  ) =>
      _repository.getRequestComplaintsGrouped(adminUserId);
}
