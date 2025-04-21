import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/update_user_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(final GetIt getIt)
      : _updateUserUsecase = getIt<UpdateUserUsecase>(),
        super(ProfileInitial());

  final UpdateUserUsecase _updateUserUsecase;
  late UserAuthModel _currentUser;

  void loadUser(final UserAuthModel user) {
    _currentUser = user;
    emit(ProfileLoaded(user));
  }

  void setAbout(final String about) {
    _currentUser = _currentUser.copyWith(about: about);
    emit(ProfileLoaded(_currentUser));
  }

  void setPosition(final String position) {
    _currentUser = _currentUser.copyWith(position: position);
    emit(ProfileLoaded(_currentUser));
  }

  void setPassword(final String password) {
    _currentUser = _currentUser.copyWith(password: password);
    emit(ProfileLoaded(_currentUser));
  }

  Future<void> updateProfile() async {
    emit(ProfileUpdating());
    final result = await _updateUserUsecase.call(_currentUser);
    result.fold(
      (final failure) => emit(ProfileError(failure.toString())),
      (final updated) => emit(ProfileUpdated(updated)),
    );
  }
}
