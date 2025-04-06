import 'package:flutter/material.dart';

import '../../../common/theme/zip_color.dart';

enum EPopupType {
  none,
  info,
  success,
  warning,
  error,
  question,
  helpNeeded;

  IconData get icon => switch (this) {
        EPopupType.info => Icons.info_outline,
        EPopupType.success => Icons.check_circle,
        EPopupType.warning => Icons.warning_amber,
        EPopupType.error => Icons.error,
        EPopupType.question => Icons.question_mark_outlined,
        EPopupType.helpNeeded => Icons.help_outline,
        _ => Icons.notifications,
      };

  Color get color => switch (this) {
        EPopupType.info => const Color(0xFF007AFF),
        EPopupType.success => const Color(0xFF28CD41),
        EPopupType.warning => const Color(0xFFFFC700),
        EPopupType.error => const Color(0xFFFF3B30),
        EPopupType.question => const Color(0xFF007AFF),
        EPopupType.helpNeeded => ZipColor.onPrimaryFixed,
        _ => const Color(0xFF007AFF),
      };
}
