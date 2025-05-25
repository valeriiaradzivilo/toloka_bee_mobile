import '../../../../data/models/complaints/request_complaints_group_model.dart';
import '../../../../data/models/complaints/user_complaints_group_model.dart';

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

  RequestComplaintsLoaded copyWith({
    final List<RequestComplaintsGroupModel>? requestComplaints,
    final List<UserComplaintsGroupModel>? userComplaints,
  }) =>
      RequestComplaintsLoaded(
        requestComplaints: requestComplaints ?? this.requestComplaints,
        userComplaints: userComplaints ?? this.userComplaints,
      );
}
