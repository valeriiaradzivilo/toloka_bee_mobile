import 'package:dartz/dartz.dart';

import '../../models/volunteer_work_model.dart';
import '../../source/volunteer_work/volunteer_work_data_source.dart';
import 'volunteer_work_repository.dart';

class VolunteerWorkRepositoryImpl implements VolunteerWorkRepository {
  final VolunteerWorkDataSource _volunteerWorkDataSource;

  VolunteerWorkRepositoryImpl(this._volunteerWorkDataSource);

  @override
  Future<Either<Fail<dynamic>, void>> startWork(
    final String volunteerId,
    final String requesterId,
    final String requestId,
  ) async {
    try {
      await _volunteerWorkDataSource.startWork(
        volunteerId,
        requesterId,
        requestId,
      );

      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, void>> confirmByVolunteer(
    final String workId,
  ) async {
    try {
      await _volunteerWorkDataSource.confirmByVolunteer(workId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, void>> confirmByRequester(
    final String workId,
  ) async {
    try {
      await _volunteerWorkDataSource.confirmByRequester(workId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, List<VolunteerWorkModel>>> getWorksByVolunteer(
    final String volunteerId,
  ) async {
    try {
      final works =
          await _volunteerWorkDataSource.getWorksByVolunteer(volunteerId);
      return Right(works);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, List<VolunteerWorkModel>>> getWorksByRequester(
    final String requesterId,
  ) async {
    try {
      final works =
          await _volunteerWorkDataSource.getWorksByRequester(requesterId);
      return Right(works);
    } catch (e) {
      return Left(Fail(e));
    }
  }
}
