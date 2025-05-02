import 'package:dartz/dartz.dart';

import '../../models/volunteer_work_model.dart';
import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';

class GetVolunteerWorksByUserIdUsecase
    extends UseCase<Either<Fail, List<VolunteerWorkModel>>, String> {
  final VolunteerWorkRepository repository;

  GetVolunteerWorksByUserIdUsecase(this.repository);

  @override
  Future<Either<Fail, List<VolunteerWorkModel>>> call(final String userId) =>
      repository.getWorksByVolunteer(userId);
}
