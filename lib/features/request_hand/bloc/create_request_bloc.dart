import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/usecase/send_notification_usecase.dart';
import 'create_request_event.dart';
import 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  CreateRequestBloc(final GetIt serviceLocator)
      : _sendNotificationUsecase = serviceLocator<SendNotificationUsecase>(),
        super(
          CreateRequestState(
            description: '',
            isRemote: false,
            isPhysicalStrength: false,
          ),
        ) {
    on<SetDeadlineEvent>((final event, final emit) {
      emit(state.copyWith(deadline: event.deadline));
    });
    on<SetDescriptionEvent>((final event, final emit) {
      emit(state.copyWith(description: event.description));
    });
    on<SetIsRemoteEvent>((final event, final emit) {
      emit(state.copyWith(isRemote: event.isRemote));
    });
    on<SetIsPhysicalStrengthEvent>((final event, final emit) {
      emit(state.copyWith(isPhysicalStrength: event.isPhysicalStrength));
    });
    on<SetPriceEvent>((final event, final emit) {
      emit(state.copyWith(price: event.price));
    });

    on<SendRequestEvent>((final event, final emit) async {
      final result = await _sendNotificationUsecase(
        state.toRequestNotificationModel(),
      );
      result.fold(
        (final failure) {
          print('Error: $failure');
        },
        (final success) {
          print('Notification sent successfully: $success');
        },
      );
    });
  }

  final SendNotificationUsecase _sendNotificationUsecase;
}
