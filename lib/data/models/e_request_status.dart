import 'dart:ui';

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
        (final element) => element.name.toLowerCase() == json.toLowerCase(),
        orElse: () => ERequestStatus.unknown,
      );

  Color get color => switch (this) {
        pending => const Color.fromARGB(255, 0, 55, 113),
        inProgress => const Color.fromARGB(255, 3, 125, 31),
        completed => const Color.fromARGB(255, 40, 48, 55),
        expired => const Color.fromARGB(255, 82, 0, 8),
        cancelled => const Color.fromARGB(255, 128, 0, 13),
        needsMorePeople => const Color.fromARGB(255, 110, 83, 2),
        unknown => const Color(0xFF6C757D),
      };

  bool get canBeHelped => switch (this) {
        pending => true,
        inProgress => false,
        completed => false,
        expired => false,
        cancelled => false,
        needsMorePeople => true,
        unknown => false,
      };

  List<ERequestStatus> get _orderForProfile => [
        ERequestStatus.inProgress,
        ERequestStatus.needsMorePeople,
        ERequestStatus.pending,
        ERequestStatus.completed,
        ERequestStatus.expired,
        ERequestStatus.cancelled,
      ];

  int compareTo(final ERequestStatus other) {
    final thisIndex = _orderForProfile.indexOf(this);
    final otherIndex = _orderForProfile.indexOf(other);

    if (thisIndex == -1 || otherIndex == -1) {
      return 0;
    }

    return thisIndex.compareTo(otherIndex);
  }
}
