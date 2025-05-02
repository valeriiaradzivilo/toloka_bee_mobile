class GetRequestsModel {
  final double latitude;
  final double longitude;
  final int radius;
  final bool onlyRemote;
  final String userId;

  const GetRequestsModel({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.onlyRemote,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'onlyRemote': onlyRemote,
        'userId': userId,
      };

  factory GetRequestsModel.fromJson(final Map<String, dynamic> json) =>
      GetRequestsModel(
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        radius: int.tryParse(json['radius'].toString()) ?? 0,
        onlyRemote: json['onlyRemote'] as bool? ?? false,
        userId: json['userId'] as String? ?? '',
      );
}
