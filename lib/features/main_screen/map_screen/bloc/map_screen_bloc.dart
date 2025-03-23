import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../common/bloc/zip_bloc.dart';
import '../../../../data/models/location_model.dart';
import '../../../../data/usecase/update_location_usecase.dart';
import '../data/location_service_state.dart';

class MapScreenBloc extends ZipBloc {
  MapScreenBloc(final GetIt locator, final BuildContext context)
      : _updateLocationUsecase = locator<UpdateLocationUsecase>() {
    // locationStream.skip(2).listen((event) {
    //   mapController.move(LatLng(event.latitude, event.longitude), 10);
    // });
    _init();
  }

  Future<void> _init() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final locationServiceEnabled =
        permission == LocationPermission.whileInUse ||
            permission != LocationPermission.always;
    _locationServiceEnabled.add(locationServiceEnabled
        ? LocationServiceState.enabled
        : LocationServiceState.disabled);
    if (locationServiceEnabled) {
      final location = await Geolocator.getCurrentPosition();
      await _updateLocationUsecase(LocationModel(
          latitude: location.latitude, longitude: location.longitude));
    }
  }

  void onMapCreated(final Position latLang) {
    mapController.camera
        .latLngToScreenPoint(LatLng(latLang.latitude, latLang.longitude));
  }

  @override
  Future<void> dispose() async {
    await _locationServiceEnabled.close();
  }

  Stream<Position> get locationStream => Geolocator.getPositionStream();
  ValueStream<LocationServiceState> get locationServiceEnabled =>
      _locationServiceEnabled.stream;

  MapController mapController = MapController();

  final BehaviorSubject<LocationServiceState> _locationServiceEnabled =
      BehaviorSubject<LocationServiceState>.seeded(
          LocationServiceState.loading);

  final UpdateLocationUsecase _updateLocationUsecase;
}
