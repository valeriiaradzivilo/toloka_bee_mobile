import 'dart:async';

import 'package:flutter/foundation.dart';
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
      final currentLocation = await Geolocator.getCurrentPosition();
      final result = await _getAllRequestsUsecase(
        GetRequestsModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          radius: 100,
        ),
      );
      result.fold(
        (final failure) => emit(const GiveHandError()),
        (final result) {
          if (state case GiveHandLoaded(:final requests)
              when !listEquals(requests, result)) {
            emit(GiveHandLoaded(result));
          } else if (state is! GiveHandLoaded) {
            emit(GiveHandLoaded(result));
          }
        },
      );
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
    add(GiveHandFetchEvent());
  });
}
