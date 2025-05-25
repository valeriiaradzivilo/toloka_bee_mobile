import 'package:dartz/dartz.dart';

import '../../models/complaints/request_complaint_model.dart';
import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class ReportRequestUsecase extends UseCase<Either, RequestComplaintModel> {
  final ComplaintRepository _repository;

  ReportRequestUsecase(this._repository);

  @override
  Future<Either<Fail, void>> call(
    final RequestComplaintModel requestComplaintModel,
  ) =>
      _repository.reportRequest(requestComplaintModel);
}
