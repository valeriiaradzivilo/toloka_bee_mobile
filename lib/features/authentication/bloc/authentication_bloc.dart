import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../common/optional_value.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/authenticate_user_usecase.dart';

class AuthenticationBloc extends ZipBloc {
  AuthenticationBloc(final GetIt locator)
      : _loginUserUsecase = locator<LoginUserUsecase>();

  ValueStream<Optional<UserAuthModel>> get userStream => _user.stream;
  Stream<bool> get isAuthenticated =>
      _user.stream.map((final user) => user is OptionalValue);
  ValueStream<PopupModel> get authPopupStream => _popupController.stream;

  Future<void> login(
    final String username,
    final String password,
  ) async {
    final isAuthenticated = switch (username) {
      'l' when kDebugMode => await _loginUserUsecase('lera@z.com', 'Lera1234!'),
      't' when kDebugMode =>
        await _loginUserUsecase('test@user.com', 'Lera1234!'),
      _ => await _loginUserUsecase(username, password),
    };

    isAuthenticated.fold(
      (final error) {
        _popupController.add(
          PopupModel(
            title: translate('login.unable'),
            message: translate('login.error'),
            type: EPopupType.error,
          ),
        );
      },
      (final user) {
        _user.add(OptionalValue(user));
        _popupController.add(
          PopupModel(
            title: translate('login.success'),
            message: translate('login.welcome', args: {'name': user.name}),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  @override
  Future<void> dispose() async {
    await _user.close();
    await _popupController.close();
    await super.dispose();
  }

  final BehaviorSubject<PopupModel> _popupController = BehaviorSubject();
  final BehaviorSubject<Optional<UserAuthModel>> _user =
      BehaviorSubject<Optional<UserAuthModel>>.seeded(const OptionalNull());

  final LoginUserUsecase _loginUserUsecase;
}
