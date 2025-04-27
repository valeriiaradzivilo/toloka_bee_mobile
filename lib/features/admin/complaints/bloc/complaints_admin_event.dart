abstract class ComplaintsAdminEvent {
  const ComplaintsAdminEvent();
}

class GetComplaintsAdminEvent extends ComplaintsAdminEvent {
  const GetComplaintsAdminEvent();
}

class BlockUserAdminEvent extends ComplaintsAdminEvent {
  const BlockUserAdminEvent({
    required this.userId,
    required this.months,
  });
  final String userId;
  final int months;
}

class BlockUserForeverEvent extends ComplaintsAdminEvent {
  const BlockUserForeverEvent(this.userId);
  final String userId;
}

class DeleteRequestEvent extends ComplaintsAdminEvent {
  const DeleteRequestEvent(this.requestId);
  final String requestId;
}

class DeleteRequestAndBlockUserEvent extends ComplaintsAdminEvent {
  const DeleteRequestAndBlockUserEvent(
    this.requestId,
  );
  final String requestId;
}
