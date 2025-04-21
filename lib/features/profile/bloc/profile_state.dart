import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/user_auth_model.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserAuthModel user;
  ProfileLoaded(this.user);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserAuthModel user;
  ProfileUpdated(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
