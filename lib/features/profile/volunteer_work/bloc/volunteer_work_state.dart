abstract class VolunteerWorkState {}

class VolunteerWorkInitial extends VolunteerWorkState {}

class VolunteerWorkLoading extends VolunteerWorkState {}

class VolunteerWorkSuccess extends VolunteerWorkState {}

class VolunteerWorkError extends VolunteerWorkState {
  final String message;

  VolunteerWorkError(this.message);
}
