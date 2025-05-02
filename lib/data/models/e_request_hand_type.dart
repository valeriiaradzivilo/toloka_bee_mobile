import 'package:flutter_translate/flutter_translate.dart';

enum ERequestHandType {
  organizationOfVolunteering,
  domesticHelp,
  medicalHelp,
  transportation,
  foodSupport,
  clothingSupport,
  furnitureSupport,
  financialAid,
  psychologicalSupport,
  other;

  String get text => switch (this) {
        ERequestHandType.organizationOfVolunteering =>
          translate('request.hand_type.organization_of_volunteering'),
        ERequestHandType.domesticHelp =>
          translate('request.hand_type.domestic_help'),
        ERequestHandType.medicalHelp =>
          translate('request.hand_type.medical_help'),
        ERequestHandType.transportation =>
          translate('request.hand_type.transportation'),
        ERequestHandType.foodSupport =>
          translate('request.hand_type.food_support'),
        ERequestHandType.clothingSupport =>
          translate('request.hand_type.clothing_support'),
        ERequestHandType.furnitureSupport =>
          translate('request.hand_type.furniture_support'),
        ERequestHandType.financialAid =>
          translate('request.hand_type.financial_aid'),
        ERequestHandType.psychologicalSupport =>
          translate('request.hand_type.psychological_support'),
        ERequestHandType.other => translate('request.hand_type.other'),
      };

  factory ERequestHandType.fromJson(final String? json) =>
      ERequestHandType.values.firstWhere(
        (final element) => element.name == json,
        orElse: () => ERequestHandType.other,
      );
}
