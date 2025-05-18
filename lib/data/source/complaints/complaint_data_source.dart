import '../../models/request_complaint_model.dart';
import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaint_model.dart';
import '../../models/user_complaints_group_model.dart';

abstract class ComplaintDataSource {
  Future<List<RequestComplaintsGroupModel>> getRequestComplaintsGrouped(
    final String adminUserId,
  );
  Future<List<UserComplaintsGroupModel>> getUserComplaintsGrouped(
    final String adminUserId,
  );

  Future<void> reportRequest(final RequestComplaintModel requestComplaintModel);

  Future<void> reportUser(final UserComplaintModel userComplaintModel);
  Future<void> deleteRequestComplaint(
    final String complaintId,
  );
  Future<void> deleteUserComplaint(
    final String complaintId,
  );
  Future<void> blockUser(
    final String userId,
    final DateTime blockUntil,
  );
  Future<void> blockUserForever(
    final String userId,
  );
}
