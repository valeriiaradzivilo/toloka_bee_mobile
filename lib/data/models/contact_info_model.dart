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

  factory ContactInfoModel.fromJson(final Map<String, dynamic> json) =>
      _$ContactInfoModelFromJson(json);
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
}
