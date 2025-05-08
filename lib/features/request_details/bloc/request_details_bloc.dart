import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../common/exceptions/request_already_accepted_exception.dart';
import '../../../common/exceptions/request_expired_exception.dart';
import '../../../common/list_extension.dart';
import '../../../data/models/request_complaint_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/models/user_complaint_model.dart';
import '../../../data/models/volunteer_work_model.dart';
import '../../../data/service/snackbar_service.dart';
import '../../../data/usecase/complaints/report_request_usecase.dart';
import '../../../data/usecase/complaints/report_user_usecase.dart';
import '../../../data/usecase/contacts/get_contacts_by_user_id_usecase.dart';
import '../../../data/usecase/get_notification_by_id_usecase.dart';
import '../../../data/usecase/requests/cancel_helping_usecase.dart';
import '../../../data/usecase/requests/cancel_request_usecase.dart';
import '../../../data/usecase/user_management/get_user_by_id_usecase.dart';
import '../../../data/usecase/volunteer_work/confirm_volunteer_work_by_requester_usecase.dart';
import '../../../data/usecase/volunteer_work/confirm_volunteer_work_by_volunteer_usecase.dart';
import '../../../data/usecase/volunteer_work/get_volunteer_work_by_request_id_usecase.dart';
import '../../../data/usecase/volunteer_work/start_volunteer_work_usecase.dart';
import 'request_details_event.dart';
import 'request_details_state.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  RequestDetailsBloc(final GetIt locator)
      : _getNotificationByIdUsecase = locator<GetNotificationByIdUsecase>(),
        _getUserByIdUsecase = locator<GetUserByIdUsecase>(),
        _cancelHelpingUsecase = locator<CancelHelpingUsecase>(),
        _cancelRequestUsecase = locator<CancelRequestUsecase>(),
        _snackbarService = locator<SnackbarService>(),
        _reportRequestUsecase = locator<ReportRequestUsecase>(),
        _reportUserUsecase = locator<ReportUserUsecase>(),
        _startVolunteerWorkUsecase = locator<StartVolunteerWorkUsecase>(),
        _getVolunteerWorkByRequestIdUsecase =
            locator<GetVolunteerWorkByRequestIdUsecase>(),
        _confirmVolunteerWorkByRequesterUsecase =
            locator<ConfirmVolunteerWorkByRequesterUsecase>(),
        _confirmVolunteerWorkByVolunteerUsecase =
            locator<ConfirmVolunteerWorkByVolunteerUsecase>(),
        _getContactByUserIdUsecase = locator<GetContactByUserIdUsecase>(),
        super(const RequestDetailsLoading()) {
    on<FetchRequestDetails>(_onFetchRequestDetails);
    on<AcceptRequest>(_onAcceptRequest);
    on<ReportRequestEvent>(_onReportRequest);
    on<ReportUserEvent>(_onReportUser);
    on<ConfirmRequestIsCompletedVolunteerEvent>(
      _confirmRequestIsCompletedVolunteer,
    );
    on<ConfirmRequestIsCompletedRequesterEvent>(
      _confirmRequestIsCompletedRequester,
    );
    on<CancelHelpingEvent>(_onCancelHelping);
    on<CancelRequestEvent>(_onCancelRequest);
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
        final user = await _getUserByIdUsecase(
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

            final contactsEither = await _getContactByUserIdUsecase(
              requestNotificationModel.userId,
            );

            final contactsResult = contactsEither.fold(
              (final failure) => null,
              (final contactInfo) => contactInfo,
            );

            final volunteerWork = await _getVolunteerWorkByRequestIdUsecase(
              requestNotificationModel.id,
            );

            final volunteerWorksResult = volunteerWork.fold(
              (final failure) => <VolunteerWorkModel>[],
              (final volunteerWorkList) => volunteerWorkList,
            );

            final volunteersFutures =
                volunteerWorksResult.map((final e) => e.volunteerId).map(
                      (final volunteerId) => _getUserByIdUsecase(volunteerId),
                    );

            final volunteers =
                await Future.wait<Either<Fail<dynamic>, UserAuthModel>>(
              volunteersFutures,
            );
            final List<UserAuthModel> volunteersList = volunteers
                .map(
                  (final e) => e.fold(
                    (final failure) => null,
                    (final userAuthModel) => userAuthModel,
                  ),
                )
                .nonNulls
                .toList();

            emit(
              RequestDetailsLoaded(
                requestNotificationModel: requestNotificationModel,
                distance: distance / 1000,
                requester: userAuthModel,
                image: base64Decode(userAuthModel.photo),
                isCurrentUsersRequest:
                    userAuthModel.id == FirebaseAuth.instance.currentUser?.uid,
                volunteerWorks: volunteerWorksResult,
                volunteers: volunteersList,
                requesterContactInfo: contactsResult,
                volunteerWorkModelCurrentUser:
                    volunteerWorksResult.firstWhereOrNull(
                  (final e) =>
                      e.volunteerId == FirebaseAuth.instance.currentUser?.uid,
                ),
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
          if (failure.failure is RequestAlreadyAcceptedException) {
            _snackbarService.show(
              PopupModel(
                title: translate('request.accept.already_accepted'),
              ),
            );
          } else if (failure.failure is RequestExpiredException) {
            _snackbarService.show(
              PopupModel(
                title: translate('request.accept.expired'),
                type: EPopupType.error,
              ),
            );
          } else {
            _snackbarService.show(
              PopupModel(
                title: translate('request.accept.error'),
                type: EPopupType.error,
              ),
            );
          }
          emit(RequestDetailsError(error: failure.toString()));
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

  Future<void> _onCancelHelping(
    final CancelHelpingEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());
    final result = await _cancelHelpingUsecase(event.workId);
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.details.cancel_error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.details.cancel_success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  Future<void> _onCancelRequest(
    final CancelRequestEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());
    final result = await _cancelRequestUsecase(
      CancelRequestUsecaseParams(
        requestId: event.requestId,
        reason: event.reason,
      ),
    );
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.details.cancel_error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.details.cancel_success'),
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

  Future<void> _confirmRequestIsCompletedVolunteer(
    final ConfirmRequestIsCompletedVolunteerEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());
    if (event.workId == null) return;
    final result = await _confirmVolunteerWorkByVolunteerUsecase(
      ConfirmVolunteerWorkParams(
        workId: event.workId!,
        requestId: event.requestId,
      ),
    );
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.confirm.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.confirm.success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  Future<void> _confirmRequestIsCompletedRequester(
    final ConfirmRequestIsCompletedRequesterEvent event,
    final Emitter<RequestDetailsState> emit,
  ) async {
    emit(const RequestDetailsLoading());
    if (event.workIds.isEmpty) return;

    final result = await _confirmVolunteerWorkByRequesterUsecase(
      ConfirmWorkByRequesterParams(
        workIds: event.workIds,
        requestId: event.requestId,
      ),
    );
    await result.fold(
      (final failure) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.confirm.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final success) async {
        _snackbarService.show(
          PopupModel(
            title: translate('request.confirm.success'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  final GetUserByIdUsecase _getUserByIdUsecase;
  final GetContactByUserIdUsecase _getContactByUserIdUsecase;
  final GetNotificationByIdUsecase _getNotificationByIdUsecase;
  final ReportRequestUsecase _reportRequestUsecase;
  final ReportUserUsecase _reportUserUsecase;
  final StartVolunteerWorkUsecase _startVolunteerWorkUsecase;
  final GetVolunteerWorkByRequestIdUsecase _getVolunteerWorkByRequestIdUsecase;
  final ConfirmVolunteerWorkByRequesterUsecase
      _confirmVolunteerWorkByRequesterUsecase;
  final ConfirmVolunteerWorkByVolunteerUsecase
      _confirmVolunteerWorkByVolunteerUsecase;
  final CancelHelpingUsecase _cancelHelpingUsecase;
  final CancelRequestUsecase _cancelRequestUsecase;

  final SnackbarService _snackbarService;
}
