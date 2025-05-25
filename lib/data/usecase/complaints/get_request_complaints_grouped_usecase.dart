import 'package:dartz/dartz.dart';

import '../../models/complaints/request_complaints_group_model.dart';
import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class GetRequestComplaintsGroupedUsecase extends UseCase<Either, String> {
  final ComplaintRepository _repository;

  GetRequestComplaintsGroupedUsecase(this._repository);

  @override
  Future<Either<Fail, List<RequestComplaintsGroupModel>>> call(
    final String adminUserId,
  ) =>
      _repository.getRequestComplaintsGrouped(adminUserId);
}
