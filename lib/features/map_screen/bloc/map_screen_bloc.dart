import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:zip_way/common/bloc/zip_bloc.dart';

class MapScreenBloc extends ZipBloc {
  MapScreenBloc() {
    locationStream.skip(1).listen((event) {
      mapController.move(LatLng(event.latitude, event.longitude), 10);
    });
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
    _locationServiceEnabled.add(permission == LocationPermission.whileInUse || permission != LocationPermission.always);
  }

  void onMapCreated(Position latLang) {
    mapController.move(LatLng(latLang.latitude, latLang.longitude), 10);
  }

  @override
  Future<void> dispose() async {
    await _locationServiceEnabled.close();
  }

  Stream<Position> get locationStream => Geolocator.getPositionStream();
  ValueStream<bool> get locationServiceEnabled => _locationServiceEnabled.stream;

  MapController mapController = MapController();

  final BehaviorSubject<bool> _locationServiceEnabled = BehaviorSubject<bool>.seeded(false);
}
