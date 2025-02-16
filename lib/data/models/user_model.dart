import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/user_model.freezed.dart';
part '../../generated/data/models/user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String id,
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.test() => UserModel(
        id: '1',
        name: 'Lerok',
        surname: 'Zip',
        username: 'lerok_zip',
        email: 'email@email.com',
        password: 'password',
      );
}
