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
      repository.confirmByVolunteer(params.workId);
}

class ConfirmVolunteerWorkParams {
  final String workId;

  ConfirmVolunteerWorkParams({required this.workId});
}
