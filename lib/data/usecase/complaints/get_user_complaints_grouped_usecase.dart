import 'package:dartz/dartz.dart';

import '../../models/user_complaints_group_model.dart';
import '../../repository/complaints/complaint_repository.dart';

class GetUserComplaintsGroupedUsecase {
  final ComplaintRepository _repository;

  GetUserComplaintsGroupedUsecase(this._repository);

  Future<Either<Fail, List<UserComplaintsGroupModel>>> call(
    final String adminUserId,
  ) =>
      _repository.getUserComplaintsGrouped(adminUserId);
}
