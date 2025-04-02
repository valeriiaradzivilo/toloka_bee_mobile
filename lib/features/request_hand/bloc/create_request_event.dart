abstract class CreateRequestEvent {}

class SetDeadlineEvent extends CreateRequestEvent {
  final DateTime? deadline;

  SetDeadlineEvent(this.deadline);
}

class SetDescriptionEvent extends CreateRequestEvent {
  final String description;

  SetDescriptionEvent(this.description);
}

class SetIsRemoteEvent extends CreateRequestEvent {
  final bool isRemote;

  SetIsRemoteEvent(this.isRemote);
}

class SetIsPhysicalStrengthEvent extends CreateRequestEvent {
  final bool isPhysicalStrength;

  SetIsPhysicalStrengthEvent(this.isPhysicalStrength);
}

class SetPriceEvent extends CreateRequestEvent {
  final double price;

  SetPriceEvent(this.price);
}

class SendRequestEvent extends CreateRequestEvent {}
