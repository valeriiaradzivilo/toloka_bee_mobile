import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaints_group_model.dart';

abstract class ComplaintDataSource {
  Future<List<RequestComplaintsGroupModel>> getRequestComplaintsGrouped(
    final String adminUserId,
  );
  Future<List<UserComplaintsGroupModel>> getUserComplaintsGrouped(
    final String adminUserId,
  );
}
