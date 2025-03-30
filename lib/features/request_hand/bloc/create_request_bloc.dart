import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_request_event.dart';
import 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  CreateRequestBloc()
      : super(
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
  }
}
