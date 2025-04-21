import 'package:flutter_translate/flutter_translate.dart';

enum ERequestStatus {
  pending,
  inProgress,
  completed,
  expired,
  cancelled,
  needsMorePeople,
  unknown;

  String get text => switch (this) {
        pending => translate('request.status.pending'),
        inProgress => translate('request.status.in_progress'),
        completed => translate('request.status.completed'),
        expired => translate('request.status.expired'),
        cancelled => translate('request.status.cancelled'),
        needsMorePeople => translate('request.status.needs_more_people'),
        unknown => translate('request.status.unknown'),
      };

  static ERequestStatus fromJson(final String json) => values.firstWhere(
        (final element) => element.name == json,
        orElse: () => ERequestStatus.unknown,
      );
}
