import 'package:dartz/dartz.dart';

import '../../models/request_complaint_model.dart';
import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaint_model.dart';
import '../../models/user_complaints_group_model.dart';

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
}
