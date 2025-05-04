abstract class VolunteerWorkEvent {}

class StartVolunteerWork extends VolunteerWorkEvent {
  final String volunteerId;
  final String requesterId;
  final String requestId;

  StartVolunteerWork({
    required this.volunteerId,
    required this.requesterId,
    required this.requestId,
  });
}

class ConfirmVolunteerWorkByVolunteer extends VolunteerWorkEvent {
  final String workId;
  final String requestId;

  ConfirmVolunteerWorkByVolunteer({
    required this.workId,
    required this.requestId,
  });
}

class ConfirmVolunteerWorkByRequester extends VolunteerWorkEvent {
  final String workId;
  final String requestId;

  ConfirmVolunteerWorkByRequester({
    required this.workId,
    required this.requestId,
  });
}
