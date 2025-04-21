import 'dart:async';
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
import '../../../../data/usecase/get_volunteers_by_location_usecase.dart';
import '../data/location_service_state.dart';

class MapScreenBloc extends ZipBloc {
  MapScreenBloc(final GetIt locator, final BuildContext context)
      : _getVolunteersByLocationUsecase =
            locator<GetVolunteersByLocationUsecase>(),
        super() {
    addSubscription(
      Stream.periodic(const Duration(seconds: 30)).listen((final _) async {
        await _searchForVolunteers();
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
      unawaited(_searchForVolunteers());
    }
  }

  Future<void> _searchForVolunteers() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final getCurrentPosition = await Geolocator.getCurrentPosition();
    debugPrint(
      'MAPBLOC Current position: ${getCurrentPosition.latitude}, ${getCurrentPosition.longitude}, locationTopic: ${getCurrentPosition.locationTopic}',
    );
    final volunteers = await _getVolunteersByLocationUsecase(
      getCurrentPosition.locationTopic,
    );
    volunteers.fold((final _) {}, (final markersCount) {
      debugPrint(
        'MAPBLOC Markers count: $markersCount',
      );
      final markers = <Marker>[];
      for (int i = 0; i < markersCount; i++) {
        final double randomValueLat =
            Random().nextDouble() / 100 + 0.02 * (i.isEven ? 1 : -1);

        final double randomValueLong =
            Random().nextDouble() / 100 + 0.02 * (i.isOdd ? 1 : -1);

        markers.add(
          Marker(
            point: LatLng(
              getCurrentPosition.latitude + randomValueLat,
              getCurrentPosition.longitude + randomValueLong,
            ),
            child: Icon(
              Icons.volunteer_activism,
              color: ZipColor.randomZipColor,
              size: 30,
            ),
          ),
        );
      }
      _volunteerMarkers.add(markers);
    });
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

  final GetVolunteersByLocationUsecase _getVolunteersByLocationUsecase;
}
