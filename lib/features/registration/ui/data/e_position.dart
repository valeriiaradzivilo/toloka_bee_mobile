import 'package:flutter_translate/flutter_translate.dart';

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

  String get text {
    switch (this) {
      case EPosition.volunteer:
        return translate('create.account.preffered.position.volunteer');
      case EPosition.requester:
        return translate('create.account.preffered.position.requester');
      case EPosition.both:
        return translate('create.account.preffered.position.both');
    }
  }
}
