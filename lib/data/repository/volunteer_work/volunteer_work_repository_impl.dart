import 'package:dartz/dartz.dart';

import '../../../common/exceptions/request_already_accepted_exception.dart';
import '../../../common/exceptions/request_expired_exception.dart';
import '../../models/e_request_status.dart';
import '../../models/e_request_update.dart';
import '../../models/volunteer_work_model.dart';
import '../../source/notifications/fcm_data_source.dart';
import '../../source/volunteer_work/volunteer_work_data_source.dart';
import 'volunteer_work_repository.dart';

class VolunteerWorkRepositoryImpl implements VolunteerWorkRepository {
  final VolunteerWorkDataSource _volunteerWorkDataSource;
  final FcmDataSource _fcmDataSource;

  VolunteerWorkRepositoryImpl(
    this._volunteerWorkDataSource,
    this._fcmDataSource,
  );

  @override
  Future<Either<Fail<dynamic>, void>> startWork(
    final String volunteerId,
    final String requesterId,
    final String requestId,
  ) async {
    try {
      final request = await _fcmDataSource.getRequestById(requestId);
      if (request.deadline.isBefore(DateTime.now())) {
        throw RequestExpiredException();
      }

      final currentVolunteersForTheRequest =
          await _volunteerWorkDataSource.getWorksByRequester(requesterId);

      if (currentVolunteersForTheRequest.length + 1 >
          request.requiredVolunteersCount) {
        throw RequestAlreadyAcceptedException();
      }

      await _volunteerWorkDataSource.startWork(
        volunteerId,
        requesterId,
        requestId,
      );

      await _fcmDataSource.updateRequest(
        request.copyWith(
          status: request.requiredVolunteersCount ==
                  currentVolunteersForTheRequest.length + 1
              ? ERequestStatus.inProgress
              : ERequestStatus.needsMorePeople,
        ),
      );

      await _fcmDataSource.sendRequestUpdateNotification(
        requestId,
        ERequestUpdate.acceptedByVolunteer,
      );

      await _fcmDataSource.subscribeToRequestUpdates(requestId);

      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, void>> confirmByVolunteer(
    final String workId,
    final String requestId,
  ) async {
    try {
      await _volunteerWorkDataSource.confirmByVolunteer(workId);
      await _fcmDataSource.sendRequestUpdateNotification(
        requestId,
        ERequestUpdate.confirmedByVolunteer,
      );
      await _fcmDataSource.unsubscribeFromRequestUpdates(requestId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, void>> confirmByRequester(
    final String workId,
    final String requestId,
  ) async {
    try {
      await _volunteerWorkDataSource.confirmByRequester(workId);
      await _fcmDataSource.sendRequestUpdateNotification(
        requestId,
        ERequestUpdate.confirmedByRequester,
      );
      await _fcmDataSource.unsubscribeFromRequestUpdates(requestId);
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

  @override
  Future<Either<Fail<dynamic>, List<VolunteerWorkModel>>> getWorksByRequestId(
    final String requestId,
  ) async {
    try {
      final works =
          await _volunteerWorkDataSource.getWorksByRequestId(requestId);
      return Right(works);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail<dynamic>, void>> cancelHelping(
    final String id,
  ) async {
    try {
      await _volunteerWorkDataSource.cancelHelping(id);
      await _fcmDataSource.sendRequestUpdateNotification(
        id,
        ERequestUpdate.canceledByVolunteer,
      );
      await _fcmDataSource.unsubscribeFromRequestUpdates(id);

      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }
}
