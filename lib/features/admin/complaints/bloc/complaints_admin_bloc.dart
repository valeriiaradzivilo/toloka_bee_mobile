import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/ui/e_popup_type.dart';
import '../../../../data/models/ui/popup_model.dart';
import '../../../../data/service/snackbar_service.dart';
import '../../../../data/usecase/complaints/block_user_forever_usecase.dart';
import '../../../../data/usecase/complaints/block_user_usecase.dart';
import '../../../../data/usecase/complaints/delete_request_and_complaints_usecase.dart';
import '../../../../data/usecase/complaints/delete_request_complaint_usecase.dart';
import '../../../../data/usecase/complaints/delete_user_complaint_usecase.dart';
import '../../../../data/usecase/complaints/get_request_complaints_grouped_usecase.dart';
import '../../../../data/usecase/complaints/get_user_complaints_grouped_usecase.dart';
import '../../../../data/usecase/requests/get_requests_by_ids_usecase.dart';
import 'complaints_admin_event.dart';
import 'complaints_admin_state.dart';

class ComplaintsAdminBloc
    extends Bloc<ComplaintsAdminEvent, ComplaintsAdminState> {
  final GetRequestComplaintsGroupedUsecase _getRequestComplaintsGroupedUsecase;
  final GetUserComplaintsGroupedUsecase _getUserComplaintsGroupedUsecase;
  final DeleteRequestAndComplaintsUsecase _deleteRequestAndComplaintsUsecase;
  final BlockUserForeverUsecase _blockUserForeverUsecase;
  final BlockUserUsecase _blockUserUsecase;

  final GetRequestsByIdsUsecase _getRequestsByIdsUsecase;

  final DeleteRequestComplaintUsecase _deleteRequestComplaintUsecase;
  final DeleteUserComplaintUsecase _deleteUserComplaintUsecase;
  final SnackbarService _snackbarService;

  ComplaintsAdminBloc(
    final GetIt locator,
  )   : _getRequestComplaintsGroupedUsecase =
            locator<GetRequestComplaintsGroupedUsecase>(),
        _getUserComplaintsGroupedUsecase =
            locator<GetUserComplaintsGroupedUsecase>(),
        _deleteRequestAndComplaintsUsecase =
            locator<DeleteRequestAndComplaintsUsecase>(),
        _blockUserForeverUsecase = locator<BlockUserForeverUsecase>(),
        _blockUserUsecase = locator<BlockUserUsecase>(),
        _deleteRequestComplaintUsecase =
            locator<DeleteRequestComplaintUsecase>(),
        _deleteUserComplaintUsecase = locator<DeleteUserComplaintUsecase>(),
        _getRequestsByIdsUsecase = locator<GetRequestsByIdsUsecase>(),
        _snackbarService = locator<SnackbarService>(),
        super(const ComplaintsAdminLoading()) {
    on<GetComplaintsAdminEvent>(_onLoadRequestComplaints);
    on<DeleteRequestEvent>(_onDeleteRequest);
    on<BlockUserForeverEvent>(_onBlockUserForever);
    on<BlockUserEvent>(_onBlockUser);
    on<DeleteRequestAndBlockUserEvent>(_onDeleteRequestAndBlockUser);
    on<DeleteUserComplaintEvent>(_onDeleteUserComplaint);
    on<DeleteRequestComplaintEvent>(_onDeleteRequestComplaint);
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

  Future<void> _onDeleteRequest(
    final DeleteRequestEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RequestComplaintsLoaded) {
      emit(const ComplaintsAdminError('Invalid state'));
      return;
    }

    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final resultRequests = await _deleteRequestAndComplaintsUsecase(
      DeleteRequestUsecaseParams(
        complaintId: event.complaintIds,
        requestId: event.requestId,
      ),
    );

    if (resultRequests.isLeft()) {
      emit(const ComplaintsAdminError('Failed to load complaints'));
      return;
    }

    final requests = resultRequests.isRight()
        ? currentState.requestComplaints
            .where((final request) => request.requestId != event.requestId)
            .toList()
        : currentState.requestComplaints;

    emit(
      currentState.copyWith(
        requestComplaints: requests,
      ),
    );
    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.request_deleted',
        ),
        type: EPopupType.success,
      ),
    );
    add(const GetComplaintsAdminEvent());
  }

  Future<void> _onBlockUserForever(
    final BlockUserForeverEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final result = await _blockUserForeverUsecase(
      event.userId,
    );

    if (result.isLeft()) {
      emit(const ComplaintsAdminError('Failed to block user'));
      return;
    }

    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.user_blocked',
        ),
        type: EPopupType.success,
      ),
    );
    add(const GetComplaintsAdminEvent());
  }

  Future<void> _onBlockUser(
    final BlockUserEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final result = await _blockUserUsecase(
      BlockUserUsecaseParams(
        userId: event.userId,
        blockUntil: event.blockUntil,
      ),
    );

    if (result.isLeft()) {
      emit(const ComplaintsAdminError('Failed to block user'));
      return;
    }

    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.user_blocked',
        ),
        type: EPopupType.success,
      ),
    );

    add(const GetComplaintsAdminEvent());
  }

  Future<void> _onDeleteRequestAndBlockUser(
    final DeleteRequestAndBlockUserEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final requestResult = await _getRequestsByIdsUsecase(
      [event.requestId],
    );

    if (requestResult.isLeft()) {
      emit(const ComplaintsAdminError('Failed to load request'));
      return;
    }
    final request = requestResult.getOrElse(() => []).firstOrNull;
    if (request == null) {
      emit(const ComplaintsAdminError('Request not found'));
      return;
    }

    final result = await _deleteRequestAndComplaintsUsecase(
      DeleteRequestUsecaseParams(
        complaintId: event.complaintIds,
        requestId: event.requestId,
      ),
    );

    if (result.isLeft()) {
      emit(const ComplaintsAdminError('Failed to delete request'));
      return;
    }

    final blockResult = await _blockUserForeverUsecase(request.userId);

    if (blockResult.isLeft()) {
      emit(const ComplaintsAdminError('Failed to block user'));
      return;
    }

    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.request_deleted_and_user_blocked',
        ),
        type: EPopupType.success,
      ),
    );

    add(const GetComplaintsAdminEvent());
  }

  Future<void> _onDeleteUserComplaint(
    final DeleteUserComplaintEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final result = await _deleteUserComplaintUsecase(
      event.complaintId,
    );

    if (result.isLeft()) {
      emit(const ComplaintsAdminError('Failed to delete user complaint'));
      return;
    }

    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.complaint_deleted',
        ),
        type: EPopupType.success,
      ),
    );
    add(const GetComplaintsAdminEvent());
  }

  Future<void> _onDeleteRequestComplaint(
    final DeleteRequestComplaintEvent event,
    final Emitter<ComplaintsAdminState> emit,
  ) async {
    emit(const ComplaintsAdminLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(const ComplaintsAdminError('User not authenticated'));
      return;
    }

    final result = await _deleteRequestComplaintUsecase(
      event.complaintId,
    );

    if (result.isLeft()) {
      emit(const ComplaintsAdminError('Failed to delete request complaint'));
      return;
    }

    _snackbarService.show(
      PopupModel(
        title: translate(
          'admin.snackbar.complaint_deleted',
        ),
        type: EPopupType.success,
      ),
    );
    add(const GetComplaintsAdminEvent());
  }
}
