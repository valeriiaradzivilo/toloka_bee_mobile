import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/e_request_status.dart';
import '../../../data/models/request_notification_model.dart';

class CreateRequestState {
  final String description;
  final bool isRemote;
  final bool isPhysicalStrength;
  final DateTime? deadline;
  final double? price;
  final LatLng location;

  CreateRequestState({
    required this.description,
    required this.isRemote,
    required this.isPhysicalStrength,
    required this.location,
    this.deadline,
    this.price,
  });

  CreateRequestState copyWith({
    final String? description,
    final bool? isRemote,
    final bool? isPhysicalStrength,
    final DateTime? deadline,
    final double? price,
    final LatLng? location,
  }) =>
      CreateRequestState(
        description: description ?? this.description,
        isRemote: isRemote ?? this.isRemote,
        isPhysicalStrength: isPhysicalStrength ?? this.isPhysicalStrength,
        deadline: deadline ?? this.deadline,
        price: price ?? this.price,
        location: location ?? this.location,
      );

  RequestNotificationModel toRequestNotificationModel() =>
      RequestNotificationModel(
        id: const Uuid().v4(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        status: ERequestStatus.pending,
        deadline: deadline ?? DateTime.now().add(const Duration(days: 7)),
        latitude: location.latitude,
        longitude: location.longitude,
        isRemote: isRemote,
        requiresPhysicalStrength: isPhysicalStrength,
        price: price?.toInt(),
        description: description,
        createdAt: DateTime.now(),
        updatedAt: null,
        title: translate('request.title'),
        body: translate('request.body'),
      );
}
