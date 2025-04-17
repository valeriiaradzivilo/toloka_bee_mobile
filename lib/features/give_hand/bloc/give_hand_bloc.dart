import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/get_requests_model.dart';
import '../../../data/usecase/get_all_requests_usecase.dart';
import 'give_hand_event.dart';
import 'give_hand_state.dart';

class GiveHandBloc extends Bloc<GiveHandEvent, GiveHandState> {
  GiveHandBloc(final GetIt serviceLocator)
      : _getAllRequestsUsecase = serviceLocator<GetAllRequestsUsecase>(),
        super(const GiveHandLoading()) {
    on<GiveHandFetchEvent>((final event, final emit) async {
      final currentState = state;

      final currentLocation = await Geolocator.getCurrentPosition();
      final result = await _getAllRequestsUsecase(
        GetRequestsModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          radius: currentState is GiveHandLoaded ? (currentState).radius : 100,
          onlyRemote: currentState is GiveHandLoaded
              ? (currentState).onlyRemote
              : false,
        ),
      );
      result.fold(
        (final failure) => emit(const GiveHandError()),
        (final result) {
          // if (currentState case GiveHandLoaded(:final requests)
          //     when !listEquals(requests, result)) {
          //   emit(GiveHandLoaded(requests: result));
          // } else if (currentState is! GiveHandLoaded) {
          emit(
            GiveHandLoaded(requests: result),
          );
          // }
        },
      );
    });

    on<ChangeRadiusEvent>((final event, final emit) {
      if (state is GiveHandLoaded) {
        final currentState = state as GiveHandLoaded;
        emit(currentState.copyWith(radius: event.radius));
      }
    });

    on<ChangeOnlyRemoteEvent>((final event, final emit) {
      if (state is GiveHandLoaded) {
        final currentState = state as GiveHandLoaded;
        emit(currentState.copyWith(onlyRemote: event.onlyRemote));
      }
    });
  }

  @override
  Future<void> close() {
    _updateListSubscription.cancel();
    return super.close();
  }

  final GetAllRequestsUsecase _getAllRequestsUsecase;
  late final StreamSubscription _updateListSubscription =
      Stream.periodic(const Duration(minutes: 1)).listen((final event) {
    add(const GiveHandFetchEvent());
  });
}
