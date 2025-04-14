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
import '../../../data/usecase/get_current_user_data_usecase.dart';
import '../../../data/usecase/login_user_usecase.dart';
import '../../../data/usecase/logout_user_usecase.dart';

class AuthenticationBloc extends ZipBloc {
  AuthenticationBloc(final GetIt locator)
      : _loginUserUsecase = locator<LoginUserUsecase>(),
        _getCurrentUserDataUsecase = locator<GetCurrentUserDataUsecase>(),
        _logoutUserUsecase = locator<LogoutUserUsecase>() {
    _init();
  }

  ValueStream<Optional<UserAuthModel>> get userStream => _user.stream;
  late Stream<bool> isAuthenticated =
      _user.stream.map((final user) => user is OptionalValue);
  ValueStream<PopupModel> get authPopupStream => _popupController.stream;

  void _init() async {
    final user = await _getCurrentUserDataUsecase.call();
    if (user.isRight()) {
      final UserAuthModel? userData = user.foldRight(
        null,
        (final userData, final _) => userData,
      );
      if (userData != null) {
        _user.add(OptionalValue(userData));
      }
    } else {
      _user.add(const OptionalNull());
    }
  }

  Future<bool> login(
    final String username,
    final String password,
  ) async {
    final isAuthenticated = switch (username) {
      'l' when kDebugMode => await _loginUserUsecase('lera@z.com', 'Lera1234!'),
      't' when kDebugMode =>
        await _loginUserUsecase('test@user.com', 'Lera1234!'),
      _ => await _loginUserUsecase(username, password),
    };

    return isAuthenticated.fold(
      (final error) {
        _popupController.add(
          PopupModel(
            title: translate('login.unable'),
            message: translate('login.error'),
            type: EPopupType.error,
          ),
        );
        return false;
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
        return true;
      },
    );
  }

  Future<void> logout() async {
    final logout = await _logoutUserUsecase.call();
    logout.fold(
      (final error) {},
      (final _) {
        _user.add(const OptionalNull());
        _popupController.add(
          PopupModel(
            title: translate('logout.success'),
            message: translate('logout.subtitle'),
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
  final GetCurrentUserDataUsecase _getCurrentUserDataUsecase;
  final LogoutUserUsecase _logoutUserUsecase;
}
