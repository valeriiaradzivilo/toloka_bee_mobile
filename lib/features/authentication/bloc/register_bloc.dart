import 'package:get_it/get_it.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/register_user_usecase.dart';

class RegisterBloc extends ZipBloc {
  RegisterBloc(final GetIt serviceLocator)
      : _registerUserUsecase = serviceLocator<RegisterUserUsecase>();

  Future<void> register(final UserAuthModel userModel) async {
    final isRegistered = await _registerUserUsecase(userModel);
    logger.info('User registered: ${isRegistered.isRight()}');
  }

  @override
  Future<void> dispose() async {}

  final RegisterUserUsecase _registerUserUsecase;
}
