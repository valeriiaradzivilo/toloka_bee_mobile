import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/user_auth_model.freezed.dart';
part '../../generated/data/models/user_auth_model.g.dart';

@freezed
class UserAuthModel with _$UserAuthModel {
  factory UserAuthModel({
    required final String id,
    required final String email,
    @JsonKey(includeFromJson: false, includeToJson: true)
    final String? password,
    required final String username,
    required final String name,
    required final String surname,
    required final String birthDate,
    required final String position,
    required final String about,
    required final String photo,
    required final String photoFormat,
    final DateTime? bannedUntil,
    @Default(false) final bool isAdmin,
  }) = _UserAuthModel;

  factory UserAuthModel.fromJson(final Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json);
}
