enum ERequestUpdate {
  acceptedByVolunteer,
  confirmedByVolunteer,
  confirmedByRequester,
  canceledByRequester,
  canceledByVolunteer;

  String get text => switch (this) {
        acceptedByVolunteer => 'request.notification.for_requester.accepted',
        confirmedByVolunteer => 'request.notification.for_requester.completed',
        confirmedByRequester => 'request.notification.for_volunteer.completed',
        canceledByRequester => 'request.notification.for_volunteer.canceled',
        canceledByVolunteer => 'request.notification.for_requester.canceled',
      };
}
