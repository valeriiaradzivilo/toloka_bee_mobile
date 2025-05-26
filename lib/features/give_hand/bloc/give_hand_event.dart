abstract class GiveHandEvent {
  const GiveHandEvent();
}

class GiveHandFetchEvent extends GiveHandEvent {
  const GiveHandFetchEvent();
}

class ChangeRadiusEvent extends GiveHandEvent {
  const ChangeRadiusEvent(this.radius);

  final int? radius;
}

class ChangeOnlyRemoteEvent extends GiveHandEvent {
  const ChangeOnlyRemoteEvent(this.onlyRemote);

  final bool onlyRemote;
}
