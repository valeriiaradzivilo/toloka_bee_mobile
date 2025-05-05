import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/list_extension.dart';

enum EPosition {
  volunteer,
  requester,
  both;

  String get name {
    switch (this) {
      case EPosition.volunteer:
        return 'Volunteer';
      case EPosition.requester:
        return 'Requester';
      case EPosition.both:
        return 'Both';
    }
  }

  String toJson() => name;

  static EPosition? fromJson(final String json) =>
      EPosition.values.firstWhereOrNull(
        (final element) => element.name.toLowerCase() == json.toLowerCase(),
      );

  String get text {
    switch (this) {
      case EPosition.volunteer:
        return translate('position.volunteer');
      case EPosition.requester:
        return translate('position.requester');
      case EPosition.both:
        return translate('position.both');
    }
  }

  String get textWantToBe {
    switch (this) {
      case EPosition.volunteer:
        return translate('create.account.preferred.position.volunteer');
      case EPosition.requester:
        return translate('create.account.preferred.position.requester');
      case EPosition.both:
        return translate('create.account.preferred.position.both');
    }
  }
}
