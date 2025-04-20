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
  final double latitude;
  final double longitude;

  const GiveHandLoaded({
    required this.requests,
    this.radius = 100,
    this.onlyRemote = false,
    required this.latitude,
    required this.longitude,
  });

  GiveHandLoaded copyWith({
    final List<RequestNotificationModel>? requests,
    final int? radius,
    final bool? onlyRemote,
    final double? latitude,
    final double? longitude,
  }) =>
      GiveHandLoaded(
        requests: requests ?? this.requests,
        radius: radius ?? this.radius,
        onlyRemote: onlyRemote ?? this.onlyRemote,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}

class GiveHandError extends GiveHandState {
  const GiveHandError();
}
