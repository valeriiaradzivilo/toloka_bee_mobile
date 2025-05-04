import 'package:dartz/dartz.dart';

import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';

class ConfirmVolunteerWorkByVolunteerUsecase
    extends UseCase<Either<Fail, void>, ConfirmVolunteerWorkParams> {
  final VolunteerWorkRepository repository;

  ConfirmVolunteerWorkByVolunteerUsecase(this.repository);

  @override
  Future<Either<Fail, void>> call(
    final ConfirmVolunteerWorkParams params,
  ) =>
      repository.confirmByVolunteer(params.workId, params.requestId);
}

class ConfirmVolunteerWorkParams {
  final String workId;
  final String requestId;

  ConfirmVolunteerWorkParams({
    required this.workId,
    required this.requestId,
  });
}
