class GetRequestsModel {
  final double latitude;
  final double longitude;
  final int radius;

  const GetRequestsModel({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };

  factory GetRequestsModel.fromJson(final Map<String, dynamic> json) =>
      GetRequestsModel(
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        radius: int.tryParse(json['radius'].toString()) ?? 0,
      );
}
