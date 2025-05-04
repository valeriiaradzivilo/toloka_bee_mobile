import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/usecase/volunteer_work/confirm_volunteer_work_by_requester_usecase.dart';
import '../../../../data/usecase/volunteer_work/confirm_volunteer_work_by_volunteer_usecase.dart';
import '../../../../data/usecase/volunteer_work/start_volunteer_work_usecase.dart';
import 'volunteer_work_event.dart';
import 'volunteer_work_state.dart';

class VolunteerWorkBloc extends Bloc<VolunteerWorkEvent, VolunteerWorkState> {
  VolunteerWorkBloc(final GetIt locator)
      : _startVolunteerWorkUsecase = locator<StartVolunteerWorkUsecase>(),
        _confirmByVolunteerUsecase =
            locator<ConfirmVolunteerWorkByVolunteerUsecase>(),
        _confirmByRequesterUsecase =
            locator<ConfirmVolunteerWorkByRequesterUsecase>(),
        super(VolunteerWorkInitial()) {
    on<StartVolunteerWork>(_onStartWork);
    on<ConfirmVolunteerWorkByVolunteer>(_onConfirmByVolunteer);
    on<ConfirmVolunteerWorkByRequester>(_onConfirmByRequester);
  }

  Future<void> _onStartWork(
    final StartVolunteerWork event,
    final Emitter<VolunteerWorkState> emit,
  ) async {
    emit(VolunteerWorkLoading());
    try {
      await _startVolunteerWorkUsecase(
        StartVolunteerWorkParams(
          volunteerId: event.volunteerId,
          requesterId: event.requesterId,
          requestId: event.requestId,
        ),
      );
      emit(VolunteerWorkSuccess());
    } catch (e) {
      emit(VolunteerWorkError(e.toString()));
    }
  }

  Future<void> _onConfirmByVolunteer(
    final ConfirmVolunteerWorkByVolunteer event,
    final Emitter<VolunteerWorkState> emit,
  ) async {
    emit(VolunteerWorkLoading());
    try {
      await _confirmByVolunteerUsecase(
        ConfirmVolunteerWorkParams(
          workId: event.workId,
          requestId: event.requestId,
        ),
      );
      emit(VolunteerWorkSuccess());
    } catch (e) {
      emit(VolunteerWorkError(e.toString()));
    }
  }

  Future<void> _onConfirmByRequester(
    final ConfirmVolunteerWorkByRequester event,
    final Emitter<VolunteerWorkState> emit,
  ) async {
    emit(VolunteerWorkLoading());
    try {
      await _confirmByRequesterUsecase(
        ConfirmVolunteerWorkParams(
          workId: event.workId,
          requestId: event.requestId,
        ),
      );
      emit(VolunteerWorkSuccess());
    } catch (e) {
      emit(VolunteerWorkError(e.toString()));
    }
  }

  final StartVolunteerWorkUsecase _startVolunteerWorkUsecase;
  final ConfirmVolunteerWorkByVolunteerUsecase _confirmByVolunteerUsecase;
  final ConfirmVolunteerWorkByRequesterUsecase _confirmByRequesterUsecase;
}
