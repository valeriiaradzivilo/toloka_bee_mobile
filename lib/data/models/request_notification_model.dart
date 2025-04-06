import 'e_request_status.dart';

class RequestNotificationModel {
  final String id;
  final String userId;
  final ERequestStatus status;
  final DateTime deadline;
  final double latitude;
  final double longitude;
  final bool isRemote;
  final bool requiresPhysicalStrength;
  final int? price;
  final String description;

  RequestNotificationModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.deadline,
    required this.latitude,
    required this.longitude,
    required this.isRemote,
    required this.requiresPhysicalStrength,
    required this.price,
    required this.description,
  });

  factory RequestNotificationModel.fromJson(final Map<String, dynamic> json) =>
      RequestNotificationModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        status: ERequestStatus.fromJson(json['status'] ?? ''),
        deadline: DateTime.tryParse(json['deadline'] ?? '') ?? DateTime.now(),
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        isRemote: json['isRemote'] ?? false,
        requiresPhysicalStrength: json['requiresPhysicalStrength'] ?? false,
        price: json['price'],
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'status': status,
        'deadline': deadline.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'isRemote': isRemote,
        'requiresPhysicalStrength': requiresPhysicalStrength,
        'price': price,
        'description': description,
      };

  RequestNotificationModel copyWith({
    final String? id,
    final String? userId,
    final ERequestStatus? status,
    final DateTime? deadline,
    final double? latitude,
    final double? longitude,
    final bool? isRemote,
    final bool? requiresPhysicalStrength,
    final int? price,
    final String? description,
  }) =>
      RequestNotificationModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        deadline: deadline ?? this.deadline,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isRemote: isRemote ?? this.isRemote,
        requiresPhysicalStrength:
            requiresPhysicalStrength ?? this.requiresPhysicalStrength,
        price: price ?? this.price,
        description: description ?? this.description,
      );
}
