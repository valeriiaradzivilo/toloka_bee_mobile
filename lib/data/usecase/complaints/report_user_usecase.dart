import 'package:dartz/dartz.dart';

import '../../models/user_complaint_model.dart';
import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class ReportUserUsecase extends UseCase<Either, UserComplaintModel> {
  final ComplaintRepository _repository;

  ReportUserUsecase(this._repository);

  @override
  Future<Either<Fail, void>> call(
    final UserComplaintModel params,
  ) =>
      _repository.reportUser(params);
}
