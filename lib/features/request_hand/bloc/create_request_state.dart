import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/e_request_hand_type.dart';
import '../../../data/models/e_request_status.dart';
import '../../../data/models/request_notification_model.dart';

sealed class CreateRequestState {
  const CreateRequestState();

  LoadedCreateRequestState get loadedState => this as LoadedCreateRequestState;
}

final class CreateRequestLoading extends CreateRequestState {
  const CreateRequestLoading();
}

class LoadedCreateRequestState extends CreateRequestState {
  final String description;
  final bool isRemote;
  final bool isPhysicalStrength;
  final DateTime? deadline;
  final double? price;
  final LatLng location;
  final ERequestHandType? requestType;
  final int requiredVolunteersCount;
  final bool userHasContactInfo;

  LoadedCreateRequestState({
    required this.description,
    required this.isRemote,
    required this.isPhysicalStrength,
    required this.location,
    this.deadline,
    this.price,
    required this.requestType,
    required this.requiredVolunteersCount,
    required this.userHasContactInfo,
  });

  LoadedCreateRequestState copyWith({
    final String? description,
    final bool? isRemote,
    final bool? isPhysicalStrength,
    final DateTime? deadline,
    final double? price,
    final LatLng? location,
    final ERequestHandType? requestType,
    final int? requiredVolunteersCount,
    final bool? userHasContactInfo,
  }) =>
      LoadedCreateRequestState(
        description: description ?? this.description,
        isRemote: isRemote ?? this.isRemote,
        isPhysicalStrength: isPhysicalStrength ?? this.isPhysicalStrength,
        deadline: deadline ?? this.deadline,
        price: price ?? this.price,
        location: location ?? this.location,
        requestType: requestType ?? this.requestType,
        requiredVolunteersCount:
            requiredVolunteersCount ?? this.requiredVolunteersCount,
        userHasContactInfo: userHasContactInfo ?? this.userHasContactInfo,
      );

  RequestNotificationModel toRequestNotificationModel() =>
      RequestNotificationModel(
        id: const Uuid().v4(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        status: ERequestStatus.pending,
        deadline: deadline ?? DateTime.now().add(const Duration(days: 7)),
        latitude: isRemote ? 0 : location.latitude,
        longitude: isRemote ? 0 : location.longitude,
        isRemote: isRemote,
        requiresPhysicalStrength: isPhysicalStrength,
        price: price?.toInt(),
        description: description,
        createdAt: DateTime.now(),
        updatedAt: null,
        title: translate('request.title'),
        body: translate('request.body'),
        requestType: requestType ?? ERequestHandType.other,
        requiredVolunteersCount: requiredVolunteersCount,
      );

  bool get canCreateRequest =>
      userHasContactInfo &&
      description.isNotEmpty &&
      (isRemote || (location.latitude != 0 && location.longitude != 0)) &&
      requiredVolunteersCount > 0;
}
