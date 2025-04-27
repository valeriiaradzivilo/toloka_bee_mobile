import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/usecase/user_management/get_current_user_data_usecase.dart';
import '../../../../data/usecase/user_management/get_user_by_id_usecase.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc(final GetIt locator)
      : _getUserByIdUsecase = locator<GetUserByIdUsecase>(),
        _getCurrentUserDataUsecase = locator<GetCurrentUserDataUsecase>(),
        super(const UserProfileLoading()) {
    on<GetUserProfileEvent>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
    final GetUserProfileEvent event,
    final Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());
    final userId = event.userId;

    final currentUser = await _getCurrentUserDataUsecase();
    if (currentUser.isLeft()) {
      emit(const UserProfileError('Failed to load data'));
      return;
    }

    currentUser.fold((final _) {
      return;
    }, (final user) {
      if (!user.isAdmin || user.id == userId) {
        emit(
          const UserProfileError(
            'You are not authorized to view this profile',
          ),
        );
        return;
      }
    });

    final result = await _getUserByIdUsecase(userId);

    result.fold(
      (final fail) {
        emit(const UserProfileError('Failed to load user profile'));
      },
      (final userAuthModel) {
        emit(
          UserProfileLoaded(userAuthModel),
        );
      },
    );
  }

  final GetUserByIdUsecase _getUserByIdUsecase;
  final GetCurrentUserDataUsecase _getCurrentUserDataUsecase;
}
