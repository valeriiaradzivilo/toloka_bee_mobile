import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/get_requests_model.dart';
import '../../../data/usecase/get_all_requests_usecase.dart';
import 'give_hand_event.dart';
import 'give_hand_state.dart';

class GiveHandBloc extends Bloc<GiveHandEvent, GiveHandState> {
  GiveHandBloc(final GetIt serviceLocator)
      : _getAllRequestsUsecase = serviceLocator<GetAllRequestsUsecase>(),
        super(const GiveHandLoading()) {
    on<GiveHandFetchEvent>(
      _onFetchRequests,
      transformer: (final events, final mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .asyncExpand(mapper),
    );
    on<ChangeRadiusEvent>(
      _onChangeRadius,
    );
    on<ChangeOnlyRemoteEvent>(_onChangeOnlyRemote);
  }

  Future<void> _onFetchRequests(
    final GiveHandFetchEvent event,
    final Emitter<GiveHandState> emit,
  ) async {
    final currentState = state;

    final currentLocation = await Geolocator.getCurrentPosition();
    final result = await _getAllRequestsUsecase(
      GetRequestsModel(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        radius: currentState is GiveHandLoaded ? (currentState).radius : 100,
        onlyRemote:
            currentState is GiveHandLoaded ? (currentState).onlyRemote : false,
      ),
    );
    await result.fold(
      (final failure) async => emit(const GiveHandError()),
      (final result) async {
        emit(
          GiveHandLoaded(
            requests: result,
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
            radius:
                currentState is GiveHandLoaded ? (currentState).radius : 100,
            onlyRemote: currentState is GiveHandLoaded
                ? (currentState).onlyRemote
                : false,
          ),
        );
      },
    );
  }

  void _onChangeRadius(
    final ChangeRadiusEvent event,
    final Emitter<GiveHandState> emit,
  ) {
    if (state is GiveHandLoaded) {
      final currentState = state as GiveHandLoaded;
      emit(currentState.copyWith(radius: event.radius));
      add(const GiveHandFetchEvent());
    }
  }

  void _onChangeOnlyRemote(
    final ChangeOnlyRemoteEvent event,
    final Emitter<GiveHandState> emit,
  ) {
    if (state is GiveHandLoaded) {
      final currentState = state as GiveHandLoaded;
      emit(currentState.copyWith(onlyRemote: event.onlyRemote));
      add(const GiveHandFetchEvent());
    }
  }

  double distanceTo(final double lat, final double long) {
    final currentState = state;
    if (currentState is GiveHandLoaded) {
      return Geolocator.distanceBetween(
            currentState.latitude,
            currentState.longitude,
            lat,
            long,
          ) /
          1000;
    }
    return 0;
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
