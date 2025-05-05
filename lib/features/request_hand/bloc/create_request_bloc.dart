import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/widgets/zip_snackbar.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/usecase/contacts/get_contacts_by_user_id_usecase.dart';
import '../../../data/usecase/requests/send_notification_usecase.dart';
import 'create_request_event.dart';
import 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  final SendNotificationUsecase _sendNotificationUsecase;
  final GetContactByUserIdUsecase _getContactByUserIdUsecase;

  CreateRequestBloc(final GetIt serviceLocator)
      : _sendNotificationUsecase = serviceLocator<SendNotificationUsecase>(),
        _getContactByUserIdUsecase =
            serviceLocator<GetContactByUserIdUsecase>(),
        super(
          const CreateRequestLoading(),
        ) {
    on<InitCreateRequestEvent>(
      (final event, final emit) async {
        final contacts = await _getContactByUserIdUsecase(
          FirebaseAuth.instance.currentUser!.uid,
        );
        final userHasContactInfo = contacts.fold(
          (final failure) => false,
          (final success) => success?.hasContactInfo ?? false,
        );
        emit(
          LoadedCreateRequestState(
            description: '',
            isRemote: false,
            isPhysicalStrength: false,
            location: const LatLng(0, 0),
            requestType: null,
            requiredVolunteersCount: 1,
            userHasContactInfo: userHasContactInfo,
            deadline: DateTime.now().add(
              const Duration(days: 7),
            ),
          ),
        );
      },
    );
    on<SetDeadlineEvent>(
      (final event, final emit) =>
          emit(state.loadedState.copyWith(deadline: event.deadline)),
    );

    on<SetDescriptionEvent>(
      (final event, final emit) =>
          emit(state.loadedState.copyWith(description: event.description)),
    );

    on<SetIsRemoteEvent>(
      (final event, final emit) => emit(
        state.loadedState.copyWith(
          isRemote: event.isRemote,
          isPhysicalStrength: false,
        ),
      ),
    );

    on<SetIsPhysicalStrengthEvent>(
      (final event, final emit) => emit(
        state.loadedState.copyWith(
          isPhysicalStrength: event.isPhysicalStrength,
          isRemote: false,
        ),
      ),
    );

    on<SetPriceEvent>(
      (final event, final emit) =>
          emit(state.loadedState.copyWith(price: event.price)),
    );

    on<SetLocationEvent>(
      (final event, final emit) => emit(
        state.loadedState
            .copyWith(location: LatLng(event.latitude, event.longitude)),
      ),
    );

    on<SetRequiredVolunteersCountEvent>(
      (final event, final emit) {
        if (event.requiredVolunteersCount == null) return;
        emit(
          state.loadedState.copyWith(
            requiredVolunteersCount: event.requiredVolunteersCount,
          ),
        );
      },
    );

    on<SendRequestEvent>((final event, final emit) async {
      final result = await _sendNotificationUsecase(
        state.loadedState.toRequestNotificationModel(),
      );
      result.fold(
        (final failure) {
          ZipSnackbar.show(
            event.context,
            PopupModel(
              title: translate('request.hand.error'),
              type: EPopupType.error,
            ),
          );
        },
        (final success) {
          ZipSnackbar.show(
            event.context,
            PopupModel(
              title: translate('request.hand.success'),
              message: translate('request.hand.thanks'),
              type: EPopupType.success,
            ),
          );
        },
      );
    });

    on<SetRequestTypeEvent>(
      (final event, final emit) =>
          emit(state.loadedState.copyWith(requestType: event.requestType)),
    );
  }
}
