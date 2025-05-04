abstract class RequestDetailsEvent {
  const RequestDetailsEvent();
}

class FetchRequestDetails extends RequestDetailsEvent {
  const FetchRequestDetails(this.requestId);
  final String requestId;
}

class AcceptRequest extends RequestDetailsEvent {
  const AcceptRequest();
}

class RemoveRequest extends RequestDetailsEvent {
  const RemoveRequest(this.requestId);
  final String requestId;
}

class ReportRequestEvent extends RequestDetailsEvent {
  const ReportRequestEvent({
    required this.requestId,
    required this.message,
  });
  final String requestId;
  final String message;
}

class ReportUserEvent extends RequestDetailsEvent {
  const ReportUserEvent({
    required this.userId,
    required this.message,
  });
  final String userId;
  final String message;
}

class ConfirmRequestIsCompletedVolunteerEvent extends RequestDetailsEvent {
  final String? workId;
  final String requestId;
  const ConfirmRequestIsCompletedVolunteerEvent({
    required this.workId,
    required this.requestId,
  });
}

class ConfirmRequestIsCompletedRequesterEvent extends RequestDetailsEvent {
  final String? workId;
  final String requestId;
  const ConfirmRequestIsCompletedRequesterEvent({
    required this.workId,
    required this.requestId,
  });
}
