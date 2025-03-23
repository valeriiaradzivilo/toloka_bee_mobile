import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../data/usecase/authenticate_user_usecase.dart';

class AuthenticationBloc extends ZipBloc {
  AuthenticationBloc(final GetIt locator)
      : _loginUserUsecase = locator<LoginUserUsecase>() {
    _init();
  }

  Future<void> _init() async {
    // Initialize any required resources or states
  }

  Future<void> authenticate(
      final String username, final String password,) async {
    final isAuthenticated = await _loginUserUsecase(username, password);
    logger.info('User $username isAuthenticated: $isAuthenticated');
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() async {
    await _isAuthenticated.close();
  }

  ValueStream<bool> get isAuthenticated => _isAuthenticated.stream;

  final BehaviorSubject<bool> _isAuthenticated =
      BehaviorSubject<bool>.seeded(false);

  final LoginUserUsecase _loginUserUsecase;
}
