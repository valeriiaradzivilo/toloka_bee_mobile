import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationConstants {
  static const String locationTopicStart = 'location_';
  static const String androidLocationChannelId = 'high_importance_channel';
}

extension LocationConstantsPositionExtension on Position {
  String get locationTopic =>
      '${LocationConstants.locationTopicStart}${_splitLocation(latitude)}_${_splitLocation(longitude)}';
}

extension LocationConstantsLatLngExtension on LatLng {
  String get locationTopic =>
      '${LocationConstants.locationTopicStart}${_splitLocation(latitude)}_${_splitLocation(longitude)}';
}

String _splitLocation(final double value) =>
    '${value.truncate()}_${value.toString().split('.')[1].substring(0, 1)}';
