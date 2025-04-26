import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/usecase/complaints/get_request_complaints_grouped_usecase.dart';
import '../../../data/usecase/complaints/get_user_complaints_grouped_usecase.dart';
import 'complaints_admin_event.dart';
import 'complaints_admin_state.dart';

class ComplaintsAdminBloc
    extends Bloc<ComplaintsAdminEvent, ComplaintsAdminState> {
  final GetRequestComplaintsGroupedUsecase _getRequestComplaintsGroupedUsecase;
  final GetUserComplaintsGroupedUsecase _getUserComplaintsGroupedUsecase;

  ComplaintsAdminBloc(
    final GetIt locator,
  )   : _getRequestComplaintsGroupedUsecase =
            locator<GetRequestComplaintsGroupedUsecase>(),
        _getUserComplaintsGroupedUsecase =
            locator<GetUserComplaintsGroupedUsecase>(),
        super(const ComplaintsAdminLoading()) {
    on<GetComplaintsAdminEvent>(_onLoadRequestComplaints);
  }

  Future<void> _onLoadRequestComplaints(
    final GetComplaintsAdminEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final resultRequests = await _getRequestComplaintsGroupedUsecase(userId);

    final resultUsers = await _getUserComplaintsGroupedUsecase(userId);

    if (resultRequests.isLeft() || resultUsers.isLeft()) {
      emit(const ComplaintsAdminError('Failed to load complaints'));
      return;
    }

    emit(
      RequestComplaintsLoaded(
        requestComplaints: resultRequests.fold(
          (final fail) => [],
          (final requestComplaints) => requestComplaints,
        ),
        userComplaints: resultUsers.fold(
          (final fail) => [],
          (final userComplaints) => userComplaints,
        ),
      ),
    );
  }
}
