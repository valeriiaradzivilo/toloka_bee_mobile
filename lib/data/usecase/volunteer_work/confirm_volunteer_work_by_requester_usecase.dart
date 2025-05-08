import 'package:dartz/dartz.dart';

import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';

class ConfirmVolunteerWorkByRequesterUsecase
    extends UseCase<Either<Fail, void>, ConfirmWorkByRequesterParams> {
  final VolunteerWorkRepository repository;

  ConfirmVolunteerWorkByRequesterUsecase(this.repository);

  @override
  Future<Either<Fail, void>> call(final ConfirmWorkByRequesterParams params) =>
      repository.confirmByRequester(params.workIds, params.requestId);
}

class ConfirmWorkByRequesterParams {
  final List<String> workIds;
  final String requestId;

  ConfirmWorkByRequesterParams({
    required this.workIds,
    required this.requestId,
  });
}
