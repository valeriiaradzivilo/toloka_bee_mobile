import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../common/bloc/zip_bloc.dart';
import '../../../../common/constants/location_constants.dart';
import '../../../../common/theme/zip_color.dart';
import '../../../../data/models/location_model.dart';
import '../../../../data/usecase/get_volunteers_by_location_usecase.dart';
import '../../../../data/usecase/update_location_usecase.dart';
import '../data/location_service_state.dart';

class MapScreenBloc extends ZipBloc {
  MapScreenBloc(final GetIt locator, final BuildContext context)
      : _updateLocationUsecase = locator<UpdateLocationUsecase>(),
        _getVolunteersByLocationUsecase =
            locator<GetVolunteersByLocationUsecase>(),
        super() {
    addSubscription(
      Stream.periodic(const Duration(seconds: 30)).listen((final _) async {
        if (FirebaseAuth.instance.currentUser == null) {
          return;
        }

        final getCurrentPosition = await Geolocator.getCurrentPosition();
        final volunteers = await _getVolunteersByLocationUsecase(
          getCurrentPosition.locationTopic,
        );
        volunteers.fold((final _) {}, (final markersCount) {
          final markers = <Marker>[];
          for (int i = 0; i < markersCount; i++) {
            final double randomValue =
                Random().nextDouble() / 10 * (i.isEven ? 1 : -1);

            markers.add(
              Marker(
                point: LatLng(
                  getCurrentPosition.latitude + randomValue,
                  getCurrentPosition.longitude + randomValue,
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  color: ZipColor.tertiary.withValues(alpha: 0.8),
                  size: 30,
                ),
              ),
            );
          }
          _volunteerMarkers.add(markers);
        });
      }),
    );
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
    _locationServiceEnabled.add(
      locationServiceEnabled
          ? LocationServiceState.enabled
          : LocationServiceState.disabled,
    );
    if (locationServiceEnabled) {
      final location = await Geolocator.getCurrentPosition();
      await _updateLocationUsecase(
        LocationModel(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );
    }
  }

  void onMapCreated(final Position latLang) {
    mapController.move(LatLng(latLang.latitude, latLang.longitude), 12);
  }

  @override
  Future<void> dispose() async {
    await _locationServiceEnabled.close();
    await _volunteerMarkers.close();
    await super.dispose();
  }

  ValueStream<LocationServiceState> get locationServiceEnabled =>
      _locationServiceEnabled.stream;

  ValueStream<List<Marker>> get volunteerMarkers => _volunteerMarkers.stream;

  MapController mapController = MapController();

  final BehaviorSubject<LocationServiceState> _locationServiceEnabled =
      BehaviorSubject<LocationServiceState>.seeded(
    LocationServiceState.loading,
  );

  final BehaviorSubject<List<Marker>> _volunteerMarkers =
      BehaviorSubject<List<Marker>>.seeded(
    [],
  );

  final UpdateLocationUsecase _updateLocationUsecase;
  final GetVolunteersByLocationUsecase _getVolunteersByLocationUsecase;
}
