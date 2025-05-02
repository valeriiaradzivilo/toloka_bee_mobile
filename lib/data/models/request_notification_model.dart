import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'e_request_hand_type.dart';
import 'e_request_status.dart';

class RequestNotificationModel implements Equatable {
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
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String title;
  final String body;
  final ERequestHandType requestType;

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
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.body,
    required this.requestType,
  });

  factory RequestNotificationModel.fromFCM(final Map<String, dynamic> json) {
    final location = jsonDecode(json['location'] as String);

    final latitude = location?['coordinates']?[1] as double?;
    final longitude = location?['coordinates']?[0] as double?;

    return RequestNotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      status: ERequestStatus.fromJson(json['status'] ?? ''),
      deadline: DateTime.tryParse(json['deadline'] ?? '') ?? DateTime.now(),
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      isRemote: bool.tryParse(json['isRemote']) ?? false,
      requiresPhysicalStrength:
          bool.tryParse(json['requiresPhysicalStrength']) ?? false,
      price: int.tryParse(json['price']),
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      title: '',
      body: '',
      requestType: ERequestHandType.fromJson(json['requestType'] ?? ''),
    );
  }

  factory RequestNotificationModel.fromJson(final Map<String, dynamic> json) =>
      RequestNotificationModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        status: ERequestStatus.fromJson(json['status'] ?? ''),
        deadline: DateTime.tryParse(json['deadline'] ?? '') ?? DateTime.now(),
        latitude: json['location']['y'] as double? ?? 0.0,
        longitude: json['location']['x'] as double? ?? 0.0,
        isRemote: json['isRemote'] as bool? ?? false,
        requiresPhysicalStrength:
            json['requiresPhysicalStrength'] as bool? ?? false,
        price: json['price'] as int?,
        description: json['description'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        requestType: ERequestHandType.fromJson(json['requestType'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'status': status.name,
        'deadline': deadline.toIso8601String(),
        'location': {
          'type': 'Point',
          'coordinates': [longitude, latitude],
        },
        'isRemote': isRemote,
        'requiresPhysicalStrength': requiresPhysicalStrength,
        'price': price,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'title': title,
        'body': body,
        'requestType': requestType.name,
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
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? title,
    final String? body,
    final ERequestHandType? requestType,
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
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
        body: body ?? this.body,
        requestType: requestType ?? this.requestType,
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        status,
        deadline,
        latitude,
        longitude,
        isRemote,
        requiresPhysicalStrength,
        price,
        description,
        createdAt,
        updatedAt,
        title,
        body,
        requestType,
      ];

  @override
  bool? get stringify => true;
}
