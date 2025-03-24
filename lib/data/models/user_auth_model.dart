import 'package:freezed_annotation/freezed_annotation.dart';

import '../../features/registration/ui/data/e_position.dart';

part '../../generated/data/models/user_auth_model.freezed.dart';
part '../../generated/data/models/user_auth_model.g.dart';

@freezed
class UserAuthModel with _$UserAuthModel {
  factory UserAuthModel({
    required final String email,
    required final String password,
    required final String username,
    required final String name,
    required final String surname,
    required final DateTime birthDate,
    required final EPosition position,
  }) = _UserAuthModel;

  factory UserAuthModel.fromJson(final Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json);
}
