import 'package:dartz/dartz.dart';

import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';

class StartVolunteerWorkUsecase
    extends UseCase<Either<Fail<dynamic>, void>, StartVolunteerWorkParams> {
  final VolunteerWorkRepository repository;

  StartVolunteerWorkUsecase(this.repository);

  @override
  Future<Either<Fail<dynamic>, void>> call(
    final StartVolunteerWorkParams params,
  ) =>
      repository.startWork(
        params.volunteerId,
        params.requesterId,
        params.requestId,
      );
}

class StartVolunteerWorkParams {
  final String volunteerId;
  final String requesterId;
  final String requestId;

  StartVolunteerWorkParams({
    required this.volunteerId,
    required this.requesterId,
    required this.requestId,
  });
}
