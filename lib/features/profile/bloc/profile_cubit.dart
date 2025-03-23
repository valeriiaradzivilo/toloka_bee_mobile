// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  void loadUser(final UserModel user) {
    emit(ProfileLoadingState());
    try {
      // Simulate data load
      Future.delayed(const Duration(seconds: 1), () {
        emit(ProfileLoadedState(user));
      });
    } catch (e) {
      emit(const ProfileErrorState('Failed to load user data'));
    }
  }
}
