// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_auth_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  void loadUser(final UserAuthModel user) {
    emit(ProfileLoadingState());

    emit(ProfileLoadedState(user));
  }
}
