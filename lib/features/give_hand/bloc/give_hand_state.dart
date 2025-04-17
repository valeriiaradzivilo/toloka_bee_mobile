import '../../../data/models/request_notification_model.dart';

sealed class GiveHandState {
  const GiveHandState();
}

class GiveHandLoading extends GiveHandState {
  const GiveHandLoading();
}

class GiveHandLoaded extends GiveHandState {
  final List<RequestNotificationModel> requests;
  final int radius;
  final bool onlyRemote;

  const GiveHandLoaded({
    required this.requests,
    this.radius = 100,
    this.onlyRemote = false,
  });

  GiveHandLoaded copyWith({
    final List<RequestNotificationModel>? requests,
    final int? radius,
    final bool? onlyRemote,
  }) =>
      GiveHandLoaded(
        requests: requests ?? this.requests,
        radius: radius ?? this.radius,
        onlyRemote: onlyRemote ?? this.onlyRemote,
      );
}

class GiveHandError extends GiveHandState {
  const GiveHandError();
}
