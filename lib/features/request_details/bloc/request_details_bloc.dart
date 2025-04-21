import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../data/usecase/get_notification_by_id_usecase.dart';
import '../../../data/usecase/get_user_by_id_usecase.dart';
import 'request_details_state.dart';
import 'request_detatils_event.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  RequestDetailsBloc(final GetIt locator)
      : _getNotificationByIdUsecase = locator<GetNotificationByIdUsecase>(),
        _getUserImageUsecase = locator<GetUserByIdUsecase>(),
        super(const RequestDetailsLoading()) {
    on<FetchRequestDetails>(_onFetchRequestDetails);
    on<AcceptRequest>(_onAcceptRequest);
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

  final GetUserByIdUsecase _getUserImageUsecase;
  final GetNotificationByIdUsecase _getNotificationByIdUsecase;
}
