import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/usecase/get_notification_by_id_usecase.dart';
import '../../../data/usecase/requests/delete_request_usecase.dart';
import '../../../data/usecase/user_management/get_user_by_id_usecase.dart';
import '../../snackbar/snackbar_service.dart';
import 'request_details_state.dart';
import 'request_detatils_event.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  RequestDetailsBloc(final GetIt locator)
      : _getNotificationByIdUsecase = locator<GetNotificationByIdUsecase>(),
        _getUserImageUsecase = locator<GetUserByIdUsecase>(),
        _deleteRequestUsecase = locator<DeleteRequestUsecase>(),
        _snackbarService = locator<SnackbarService>(),
        super(const RequestDetailsLoading()) {
    on<FetchRequestDetails>(_onFetchRequestDetails);
    on<AcceptRequest>(_onAcceptRequest);
    on<RemoveRequest>(_onRemoveRequest);
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
              currentPosition.latitude,
              currentPosition.longitude,
              requestNotificationModel.latitude,
              requestNotificationModel.longitude,
            );
            emit(
              RequestDetailsLoaded(
                requestNotificationModel: requestNotificationModel,
                distance: distance,
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
    emit(const RequestDetailsLoading());
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

  final GetUserByIdUsecase _getUserImageUsecase;
  final GetNotificationByIdUsecase _getNotificationByIdUsecase;
  final DeleteRequestUsecase _deleteRequestUsecase;
  final SnackbarService _snackbarService;
}
