import '../../../data/models/request_complaints_group_model.dart';
import '../../../data/models/user_complaints_group_model.dart';

sealed class ComplaintsAdminState {
  const ComplaintsAdminState();
}

class ComplaintsAdminLoading extends ComplaintsAdminState {
  const ComplaintsAdminLoading();
}

class ComplaintsAdminError extends ComplaintsAdminState {
  final String message;

  const ComplaintsAdminError(this.message);
}

class RequestComplaintsLoaded extends ComplaintsAdminState {
  final List<RequestComplaintsGroupModel> requestComplaints;
  final List<UserComplaintsGroupModel> userComplaints;

  const RequestComplaintsLoaded({
    required this.requestComplaints,
    required this.userComplaints,
  });
}
