enum ERequestUpdate {
  acceptedByVolunteer,
  confirmedByVolunteer,
  confirmedByRequester,
  cancelledByRequester,
  cancelledByVolunteer;

  String get text => switch (this) {
        acceptedByVolunteer => 'request.notification.for_requester.accepted',
        confirmedByVolunteer => 'request.notification.for_requester.completed',
        confirmedByRequester => 'request.notification.for_volunteer.completed',
        cancelledByRequester => 'request.notification.for_volunteer.cancelled',
        cancelledByVolunteer => 'request.notification.for_requester.cancelled',
      };
}
