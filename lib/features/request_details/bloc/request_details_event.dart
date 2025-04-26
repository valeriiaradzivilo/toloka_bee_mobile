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
