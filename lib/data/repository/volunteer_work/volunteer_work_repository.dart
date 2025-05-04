import 'package:dartz/dartz.dart';

import '../../models/volunteer_work_model.dart';

abstract interface class VolunteerWorkRepository {
  Future<Either<Fail, void>> startWork(
    final String volunteerId,
    final String requesterId,
    final String requestId,
  );
  Future<Either<Fail, void>> confirmByVolunteer(
    final String workId,
    final String requestId,
  );
  Future<Either<Fail, void>> confirmByRequester(
    final String workId,
    final String requestId,
  );
  Future<Either<Fail, List<VolunteerWorkModel>>> getWorksByVolunteer(
    final String volunteerId,
  );
  Future<Either<Fail, List<VolunteerWorkModel>>> getWorksByRequester(
    final String requesterId,
  );
  Future<Either<Fail, List<VolunteerWorkModel>>> getWorksByRequestId(
    final String requestId,
  );
}
