import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/request_complaint_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_complaint_model.dart';
import '../../../data/service/snackbar_service.dart';
import '../../../data/usecase/complaints/report_request_usecase.dart';
import '../../../data/usecase/complaints/report_user_usecase.dart';
import '../../../data/usecase/get_notification_by_id_usecase.dart';
import '../../../data/usecase/requests/delete_request_usecase.dart';
import '../../../data/usecase/user_management/get_user_by_id_usecase.dart';
import '../../../data/usecase/volunteer_work/start_volunteer_work_usecase.dart';
import 'request_details_event.dart';
import 'request_details_state.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  RequestDetailsBloc(final GetIt locator)
      : _getNotificationByIdUsecase = locator<GetNotificationByIdUsecase>(),
        _getUserImageUsecase = locator<GetUserByIdUsecase>(),
        _deleteRequestUsecase = locator<DeleteRequestUsecase>(),
        _snackbarService = locator<SnackbarService>(),
        _reportRequestUsecase = locator<ReportRequestUsecase>(),
        _reportUserUsecase = locator<ReportUserUsecase>(),
        _startVolunteerWorkUsecase = locator<StartVolunteerWorkUsecase>(),
        super(const RequestDetailsLoading()) {
    on<FetchRequestDetails>(_onFetchRequestDetails);
    on<AcceptRequest>(_onAcceptRequest);
    on<RemoveRequest>(_onRemoveRequest);
    on<ReportRequestEvent>(_onReportRequest);
    on<ReportUserEvent>(_onReportUser);
  }

  Future<void> _onFetchRequestDetails(
    final FetchRequestDetails event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());

    final request = await _getNotificationByIdUsecase(event.requestId);

    await request.fold(
      (final failure) async =>
          emit(RequestDetailsError(error: failure.toString())),
      (final requestNotificationModel) async {
        final user = await _getUserImageUsecase(
          requestNotificationModel.userId,
        );

        await user.fold(
          (final failure) async =>
              emit(RequestDetailsError(error: failure.toString())),
          (final userAuthModel) async {
            final currentPosition = await Geolocator.getCurrentPosition();
            final distance = Geolocator.distanceBetween(
              requestNotificationModel.latitude,
              requestNotificationModel.longitude,
              currentPosition.latitude,
              currentPosition.longitude,
            );

            emit(
              RequestDetailsLoaded(
                requestNotificationModel: requestNotificationModel,
                distance: distance / 1000,
                user: userAuthModel,
                image: base64Decode(userAuthModel.photo),
                isCurrentUsersRequest:
                    userAuthModel.id == FirebaseAuth.instance.currentUser?.uid,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAcceptRequest(
    final AcceptRequest event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is RequestDetailsLoaded) {
      emit(const RequestDetailsLoading());
      final result = await _startVolunteerWorkUsecase(
        StartVolunteerWorkParams(
          volunteerId: FirebaseAuth.instance.currentUser!.uid,
          requesterId: currentState.requestNotificationModel.userId,
          requestId: currentState.requestNotificationModel.id,
        ),
      );

      result.fold(
        (final failure) {
          emit(RequestDetailsError(error: failure.toString()));
          _snackbarService.show(
            PopupModel(
              title: translate('request.accept.error'),
              type: EPopupType.error,
            ),
          );
        },
        (final success) {
          emit(const RequestDetailsLoading());
          _snackbarService.show(
            PopupModel(
              title: translate('request.accept.success'),
              type: EPopupType.success,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRemoveRequest(
    final RemoveRequest event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());
    final result = await _deleteRequestUsecase(event.requestId);
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.delete.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.delete.success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  Future<void> _onReportRequest(
    final ReportRequestEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    final result = await _reportRequestUsecase(
      RequestComplaintModel(
        requestId: event.requestId,
        reporterUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
        reason: event.message,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.report.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.report.success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  Future<void> _onReportUser(
    final ReportUserEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    final result = await _reportUserUsecase(
      UserComplaintModel(
        reportedUserId: event.userId,
        reporterUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
        reason: event.message,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.report.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.report.success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  final GetUserByIdUsecase _getUserImageUsecase;
  final GetNotificationByIdUsecase _getNotificationByIdUsecase;
  final DeleteRequestUsecase _deleteRequestUsecase;
  final ReportRequestUsecase _reportRequestUsecase;
  final ReportUserUsecase _reportUserUsecase;
  final StartVolunteerWorkUsecase _startVolunteerWorkUsecase;

  final SnackbarService _snackbarService;
}
