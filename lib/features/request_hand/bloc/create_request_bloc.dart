import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/usecase/send_notification_usecase.dart';
import 'create_request_event.dart';
import 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  final SendNotificationUsecase _sendNotificationUsecase;

  CreateRequestBloc(final GetIt serviceLocator)
      : _sendNotificationUsecase = serviceLocator<SendNotificationUsecase>(),
        super(
          CreateRequestState(
            description: '',
            isRemote: false,
            location: const LatLng(0, 0),
            isPhysicalStrength: false,
            deadline: DateTime.now().add(const Duration(days: 7)),
          ),
        ) {
    on<SetDeadlineEvent>(
      (final event, final emit) =>
          emit(state.copyWith(deadline: event.deadline)),
    );

    on<SetDescriptionEvent>(
      (final event, final emit) =>
          emit(state.copyWith(description: event.description)),
    );

    on<SetIsRemoteEvent>(
      (final event, final emit) => emit(
        state.copyWith(
          isRemote: event.isRemote,
          isPhysicalStrength: false,
        ),
      ),
    );

    on<SetIsPhysicalStrengthEvent>(
      (final event, final emit) => emit(
        state.copyWith(
          isPhysicalStrength: event.isPhysicalStrength,
          isRemote: false,
        ),
      ),
    );

    on<SetPriceEvent>(
      (final event, final emit) => emit(state.copyWith(price: event.price)),
    );

    on<SetLocationEvent>(
      (final event, final emit) => emit(
        state.copyWith(location: LatLng(event.latitude, event.longitude)),
      ),
    );

    on<SendRequestEvent>((final event, final emit) async {
      await _sendNotificationUsecase(state.toRequestNotificationModel());

      // TODO: Handle success and error states
    });
  }
}
