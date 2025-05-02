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

  ConfirmVolunteerWorkByVolunteer({required this.workId});
}

class ConfirmVolunteerWorkByRequester extends VolunteerWorkEvent {
  final String workId;

  ConfirmVolunteerWorkByRequester({required this.workId});
}
