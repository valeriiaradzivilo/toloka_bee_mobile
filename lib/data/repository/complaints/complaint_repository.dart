import 'package:dartz/dartz.dart';

import '../../models/complaints/request_complaint_model.dart';
import '../../models/complaints/request_complaints_group_model.dart';
import '../../models/complaints/user_complaint_model.dart';
import '../../models/complaints/user_complaints_group_model.dart';

abstract class ComplaintRepository {
  Future<Either<Fail, List<RequestComplaintsGroupModel>>>
      getRequestComplaintsGrouped(final String adminUserId);
  Future<Either<Fail, List<UserComplaintsGroupModel>>> getUserComplaintsGrouped(
    final String adminUserId,
  );
  Future<Either<Fail, void>> reportRequest(
    final RequestComplaintModel requestComplaintModel,
  );

  Future<Either<Fail, void>> reportUser(
    final UserComplaintModel userComplaintModel,
  );
  Future<Either<Fail, void>> deleteRequestComplaint(
    final String complaintId,
  );
  Future<Either<Fail, void>> blockUser(
    final String userId,
    final DateTime blockUntil,
  );
  Future<Either<Fail, void>> blockUserForever(
    final String userId,
  );
  Future<Either<Fail, void>> deleteUserComplaint(
    final String complaintId,
  );
}
