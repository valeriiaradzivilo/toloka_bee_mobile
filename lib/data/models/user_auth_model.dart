import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/user_auth_model.freezed.dart';
part '../../generated/data/models/user_auth_model.g.dart';

@freezed
class UserAuthModel with _$UserAuthModel {
  factory UserAuthModel({
    required String email,
    required String password,
  }) = _UserAuthModel;

  factory UserAuthModel.fromJson(Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json);
}
