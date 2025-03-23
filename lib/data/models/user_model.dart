import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/user_model.freezed.dart';
part '../../generated/data/models/user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required final String id,
    required final String name,
    required final String surname,
    required final String username,
    required final String email,
    required final String password,
  }) = _UserModel;

  factory UserModel.fromJson(final Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.test() => UserModel(
        id: '1',
        name: 'Lerok',
        surname: 'Zip',
        username: 'lerok_zip',
        email: 'email@email.com',
        password: 'password',
      );
}
