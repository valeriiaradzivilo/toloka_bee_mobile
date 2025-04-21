import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/update_user_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(final GetIt getIt)
      : _updateUserUsecase = getIt<UpdateUserUsecase>(),
        super(const ProfileLoading());

  final UpdateUserUsecase _updateUserUsecase;
  late UserAuthModel _currentUser;

  UserAuthModel get currentUser => _currentUser;

  void loadUser(final UserAuthModel user) {
    _currentUser = user;
    emit(ProfileLoaded(user));
  }

  void setAbout(final String about) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          changedUser: currentState.changedUser.copyWith(about: about),
        ),
      );
    }
  }

  void setPosition(final String position) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          changedUser: currentState.changedUser.copyWith(position: position),
        ),
      );
    }
  }

  void setPassword(final String password) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          changedUser: currentState.changedUser.copyWith(password: password),
        ),
      );
    }
  }

  void setOldPassword(final String oldPassword) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          oldPassword: oldPassword,
        ),
      );
    }
  }

  void setName(final String name) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          changedUser: currentState.changedUser.copyWith(name: name),
        ),
      );
    }
  }

  void setSurname(final String surname) {
    if (state case final ProfileUpdating currentState) {
      emit(
        currentState.copyWith(
          changedUser: currentState.changedUser.copyWith(surname: surname),
        ),
      );
    }
  }

  Future<void> updateProfile() async {
    if (state is! ProfileUpdating) return;

    final currentState = state as ProfileUpdating;
    emit(const ProfileLoading());
    final result = await _updateUserUsecase.call(currentState);
    result.fold(
      (final failure) => emit(
        const ProfileError(
          'Unable to update user.\nCheck if the old password is correct...',
        ),
      ),
      (final _) {
        _currentUser = currentState.changedUser;
        emit(ProfileUpdated(_currentUser));
      },
    );
  }

  void editUser() {
    emit(
      ProfileUpdating(
        changedUser: _currentUser,
      ),
    );
  }

  void cancelEdit() async {
    emit(const ProfileLoading());
    await Future.delayed(Duration.zero);
    emit(ProfileLoaded(_currentUser));
  }
}
