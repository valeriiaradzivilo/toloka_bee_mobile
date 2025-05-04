import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationConstants {
  static const String locationTopicStart = 'location_';
  static const String androidLocationChannelId = 'high_importance_channel';
}

extension LocationConstantsPositionExtension on Position {
  String get locationTopic =>
      '${LocationConstants.locationTopicStart}${_splitLocation(latitude)}_${_splitLocation(longitude)}';

  List<String> get locationTopicList => [
        for (final double latLoc in _closeLocations(latitude))
          for (final double longLoc in _closeLocations(longitude))
            '${LocationConstants.locationTopicStart}${_splitLocation(latLoc)}_${_splitLocation(longLoc)}',
      ];
}

extension LocationConstantsLatLngExtension on LatLng {
  String get locationTopic =>
      '${LocationConstants.locationTopicStart}${_splitLocation(latitude)}_${_splitLocation(longitude)}';
}

String _splitLocation(final double value) =>
    '${value.truncate()}_${value.toString().split('.')[1].substring(0, 1)}';

List<double> _closeLocations(final double value) {
  final result = <double>[];
  final firstPart = value.truncate();
  final secondPart = int.parse(value.toString().split('.')[1].substring(0, 1));

  for (int i = -1; i < 2; i++) {
    if (secondPart + i < 0) {
      continue;
    }

    result.add(
      double.parse(
        '$firstPart.${secondPart + i}',
      ),
    );
  }
  return result;
}
