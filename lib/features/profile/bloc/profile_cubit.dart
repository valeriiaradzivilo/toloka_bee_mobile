import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/contact_info_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/contacts/get_contacts_by_user_id_usecase.dart';
import '../../../data/usecase/contacts/save_contacts_usecase.dart';
import '../../../data/usecase/contacts/update_contacts_usecase.dart';
import '../../../data/usecase/requests/get_requests_by_user_id_usecase.dart';
import '../../../data/usecase/user_management/update_user_usecase.dart';
import '../../snackbar/snackbar_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(final GetIt getIt)
      : _updateUserUsecase = getIt<UpdateUserUsecase>(),
        _getRequestsByUserIdUsecase = getIt<GetRequestsByUserIdUsecase>(),
        _getContactByUserIdUsecase = getIt<GetContactByUserIdUsecase>(),
        _updateContactUsecase = getIt<UpdateContactUsecase>(),
        _snackbarService = getIt<SnackbarService>(),
        _saveContactUsecase = getIt<SaveContactUsecase>(),
        super(const ProfileLoading());

  final UpdateUserUsecase _updateUserUsecase;
  final GetRequestsByUserIdUsecase _getRequestsByUserIdUsecase;
  final GetContactByUserIdUsecase _getContactByUserIdUsecase;
  final UpdateContactUsecase _updateContactUsecase;
  final SaveContactUsecase _saveContactUsecase;

  final SnackbarService _snackbarService;

  late UserAuthModel _currentUser;

  UserAuthModel get currentUser => _currentUser;

  void loadUser(final UserAuthModel user) async {
    _currentUser = user;
    final result = await _getRequestsByUserIdUsecase.call(user.id);

    await result.fold(
      (final failure) async => emit(
        ProfileLoaded(
          user: user,
          requests: [],
          contactInfo: null,
        ),
      ),
      (final requests) async {
        final contactsResult = await _getContactByUserIdUsecase.call(user.id);
        contactsResult.fold(
          (final failure) => emit(
            ProfileLoaded(
              user: user,
              requests: requests,
              contactInfo: null,
            ),
          ),
          (final contactInfo) => emit(
            ProfileLoaded(
              user: user,
              requests: requests,
              contactInfo: contactInfo,
            ),
          ),
        );
      },
    );
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

  void cancelEdit() {
    emit(const ProfileLoading());
    loadUser(_currentUser);
  }

  void addContactInfo({
    required final String? phone,
    required final String? viber,
    required final String? telegram,
    required final String? whatsapp,
    required final ContactMethod preferredMethod,
  }) async {
    if (state case final ProfileLoaded currentState) {
      final newContactInfo = switch (currentState.contactInfo == null) {
        true => ContactInfoModel(
            id: '',
            userId: currentState.user.id,
            phone: phone,
            viber: viber,
            telegram: telegram,
            whatsapp: whatsapp,
            preferredMethod: preferredMethod,
          ),
        false => currentState.contactInfo!.copyWith(
            phone: phone,
            viber: viber,
            telegram: telegram,
            whatsapp: whatsapp,
            preferredMethod: preferredMethod,
          )
      };

      final result = switch (newContactInfo.id.isEmpty) {
        true => await _saveContactUsecase.call(
            newContactInfo.copyWith(
              id: const Uuid().v4(),
            ),
          ),
        false => await _updateContactUsecase.call(
            newContactInfo,
          )
      };

      result.fold(
        (final failure) => _snackbarService.show(
          PopupModel(
            title: translate('profile.contacts.error'),
            type: EPopupType.error,
          ),
        ),
        (final _) {
          _snackbarService.show(
            PopupModel(
              title: translate(
                'profile.contacts.updated',
              ),
              type: EPopupType.success,
            ),
          );
          emit(
            currentState.copyWith(
              contactInfo: newContactInfo,
            ),
          );
        },
      );
    }
  }

  @override
  Future<void> close() async {
    await _requestSubscription.cancel();
    await super.close();
  }

  late final _requestSubscription =
      Stream.periodic(const Duration(seconds: 5)).listen((final result) async {
    loadUser(_currentUser);
  });
}
