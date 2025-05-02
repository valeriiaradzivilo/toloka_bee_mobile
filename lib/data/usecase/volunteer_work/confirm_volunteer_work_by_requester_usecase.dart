import 'package:dartz/dartz.dart';

import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';
import 'confirm_volunteer_work_by_volunteer_usecase.dart';

class ConfirmVolunteerWorkByRequesterUsecase
    extends UseCase<Either<Fail, void>, ConfirmVolunteerWorkParams> {
  final VolunteerWorkRepository repository;

  ConfirmVolunteerWorkByRequesterUsecase(this.repository);

  @override
  Future<Either<Fail, void>> call(final ConfirmVolunteerWorkParams params) =>
      repository.confirmByRequester(params.workId);
}
