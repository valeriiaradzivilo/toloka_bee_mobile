abstract class ComplaintsAdminEvent {
  const ComplaintsAdminEvent();
}

class GetComplaintsAdminEvent extends ComplaintsAdminEvent {
  const GetComplaintsAdminEvent();
}

class BlockUserEvent extends ComplaintsAdminEvent {
  const BlockUserEvent({
    required this.userId,
    required this.blockUntil,
  });
  final String userId;
  final DateTime blockUntil;
}

class BlockUserForeverEvent extends ComplaintsAdminEvent {
  const BlockUserForeverEvent(this.userId);
  final String userId;
}

class DeleteRequestEvent extends ComplaintsAdminEvent {
  const DeleteRequestEvent({
    required this.requestId,
    required this.complaintIds,
  });
  final String requestId;
  final List<String> complaintIds;
}

class DeleteRequestAndBlockUserEvent extends ComplaintsAdminEvent {
  const DeleteRequestAndBlockUserEvent({
    required this.requestId,
    required this.complaintIds,
  });
  final String requestId;
  final List<String> complaintIds;
}

class DeleteUserComplaintEvent extends ComplaintsAdminEvent {
  const DeleteUserComplaintEvent({
    required this.complaintId,
  });
  final List<String> complaintId;
}

class DeleteRequestComplaintEvent extends ComplaintsAdminEvent {
  const DeleteRequestComplaintEvent({
    required this.complaintId,
  });
  final List<String> complaintId;
}
