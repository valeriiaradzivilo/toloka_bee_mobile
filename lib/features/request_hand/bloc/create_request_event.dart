import 'package:flutter/material.dart';

import '../../../data/models/e_request_hand_type.dart';

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

class SetLocationEvent extends CreateRequestEvent {
  final double latitude;
  final double longitude;

  SetLocationEvent(this.latitude, this.longitude);
}

class SendRequestEvent extends CreateRequestEvent {
  final BuildContext context;

  SendRequestEvent(this.context);
}

class SetRequestTypeEvent extends CreateRequestEvent {
  final ERequestHandType requestType;

  SetRequestTypeEvent(this.requestType);
}

class SetRequiredVolunteersCountEvent extends CreateRequestEvent {
  final int requiredVolunteersCount;

  SetRequiredVolunteersCountEvent(this.requiredVolunteersCount);
}
