import 'package:dartz/dartz.dart';

import '../../models/complaints/user_complaints_group_model.dart';
import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class GetUserComplaintsGroupedUsecase extends UseCase<Either, String> {
  final ComplaintRepository _repository;

  GetUserComplaintsGroupedUsecase(this._repository);

  @override
  Future<Either<Fail, List<UserComplaintsGroupModel>>> call(
    final String adminUserId,
  ) =>
      _repository.getUserComplaintsGrouped(adminUserId);
}
