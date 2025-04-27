import 'package:flutter_translate/flutter_translate.dart';

enum EPredefinedReportMessage {
  incorrectUseOfTheApp,
  fakeUser,
  offensiveBehavior,
  scamAttempt,
  inappropriateContent,
  spamActivity,
  violenceOrThreats,
  falseInformation,
  unauthorizedAdvertising,
  privacyViolation,
  other;

  String get text => switch (this) {
        incorrectUseOfTheApp =>
          translate('complaints.predefine.incorrect_use_of_the_app'),
        fakeUser => translate('complaints.predefine.fake_user'),
        offensiveBehavior =>
          translate('complaints.predefine.offensive_behavior'),
        scamAttempt => translate('complaints.predefine.scam_attempt'),
        inappropriateContent =>
          translate('complaints.predefine.inappropriate_content'),
        spamActivity => translate('complaints.predefine.spam_activity'),
        violenceOrThreats =>
          translate('complaints.predefine.violence_or_threats'),
        falseInformation => translate('complaints.predefine.false_information'),
        unauthorizedAdvertising =>
          translate('complaints.predefine.unauthorized_advertising'),
        privacyViolation => translate('complaints.predefine.privacy_violation'),
        other => translate('complaints.predefine.other'),
      };
}
