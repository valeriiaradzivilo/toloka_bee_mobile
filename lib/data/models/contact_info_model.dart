import 'package:flutter_translate/flutter_translate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/contact_info_model.freezed.dart';
part '../../generated/data/models/contact_info_model.g.dart';

@freezed
class ContactInfoModel with _$ContactInfoModel {
  const factory ContactInfoModel({
    required final String id,
    required final String userId,
    required final ContactMethod preferredMethod,
    @JsonKey(includeIfNull: false) final String? phone,
    @JsonKey(includeIfNull: false) final String? email,
    @JsonKey(includeIfNull: false) final String? viber,
    @JsonKey(includeIfNull: false) final String? telegram,
    @JsonKey(includeIfNull: false) final String? whatsapp,
  }) = _ContactInfoModel;

  const ContactInfoModel._();

  factory ContactInfoModel.fromJson(final Map<String, dynamic> json) =>
      _$ContactInfoModelFromJson(json);

  bool get hasContactInfo =>
      phone != null ||
      email != null ||
      viber != null ||
      telegram != null ||
      whatsapp != null;
}

enum ContactMethod {
  @JsonValue('PHONE')
  phone,
  @JsonValue('EMAIL')
  email,
  @JsonValue('VIBER')
  viber,
  @JsonValue('TELEGRAM')
  telegram,
  @JsonValue('WHATSAPP')
  whatsapp;

  String get text => switch (this) {
        phone => translate('contacts.phone'),
        email => translate('contacts.email'),
        viber => translate('contacts.viber'),
        telegram => translate('contacts.telegram'),
        whatsapp => translate('contacts.whatsapp'),
      };

  Uri? uri(final String value) {
    switch (this) {
      case ContactMethod.telegram:
        final username = value.split('@').last;
        return Uri.parse('https://t.me/$username');

      case ContactMethod.whatsapp:
        String number = value;
        if (number.startsWith('+')) {
          number = number.substring(1);
        }
        if (number.startsWith('0')) {
          number = number.substring(1);
        }
        if (number.startsWith('0')) {
          number = number.substring(1);
        }
        return Uri.parse('https://wa.me/$value');
      case ContactMethod.phone:
        return Uri.parse('tel:$value');
      case ContactMethod.email:
        return Uri.parse('mailto:$value');

      default:
        return null;
    }
  }

  String get hint => switch (this) {
        phone => translate('contacts.phone_hint'),
        email => translate('contacts.email_hint'),
        viber => translate('contacts.viber_hint'),
        telegram => translate('contacts.telegram_hint'),
        whatsapp => translate('contacts.whatsapp_hint'),
      };
}
