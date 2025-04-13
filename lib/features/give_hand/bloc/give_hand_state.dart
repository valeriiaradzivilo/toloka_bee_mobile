import '../../../data/models/request_notification_model.dart';

sealed class GiveHandState {
  const GiveHandState();
}

class GiveHandLoading extends GiveHandState {
  const GiveHandLoading();
}

class GiveHandLoaded extends GiveHandState {
  final List<RequestNotificationModel> requests;

  const GiveHandLoaded(this.requests);
}

class GiveHandError extends GiveHandState {
  const GiveHandError();
}
