import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/constants/request_constants.dart';
import '../../../common/exceptions/request_limit_reached_for_today.dart';
import '../../../common/widgets/toloka_snackbar.dart';
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
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(st.copyWith(deadline: event.deadline));
        }
      },
    );

    on<SetDescriptionEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(st.copyWith(description: event.description));
        }
      },
    );

    on<SetIsRemoteEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(
            st.copyWith(
              isRemote: event.isRemote,
              isPhysicalStrength: false,
            ),
          );
        }
      },
    );

    on<SetIsPhysicalStrengthEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(
            st.copyWith(
              isPhysicalStrength: event.isPhysicalStrength,
              isRemote: false,
            ),
          );
        }
      },
    );

    on<SetPriceEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(
            st.copyWith(
              price: event.price,
            ),
          );
        }
      },
    );

    on<SetLocationEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st
            when st.location.latitude != event.latitude &&
                st.location.longitude != event.longitude) {
          emit(
            st.copyWith(
              location: LatLng(event.latitude, event.longitude),
            ),
          );
        }
      },
    );

    on<SetRequiredVolunteersCountEvent>(
      (final event, final emit) {
        if (event.requiredVolunteersCount == null) return;
        if (state case final LoadedCreateRequestState st) {
          emit(
            st.copyWith(
              requiredVolunteersCount: event.requiredVolunteersCount,
            ),
          );
        }
      },
    );

    on<SendRequestEvent>((final event, final emit) async {
      if (state case final LoadedCreateRequestState state) {
        final result = await _sendNotificationUsecase(
          state.toRequestNotificationModel(),
        );
        result.fold(
          (final failure) {
            if (failure is RequestLimitReachedForToday) {
              TolokaSnackbar.show(
                event.context,
                PopupModel(
                  title: translate('request.limit_reached'),
                  message: translate(
                    'request.limit_reached_message',
                    args: {
                      'limit': RequestConstants.requestLimitForTheDay,
                    },
                  ),
                  type: EPopupType.error,
                ),
              );
              return;
            }
            TolokaSnackbar.show(
              event.context,
              PopupModel(
                title: translate('request.hand.error'),
                type: EPopupType.error,
              ),
            );
          },
          (final success) {
            TolokaSnackbar.show(
              event.context,
              PopupModel(
                title: translate('request.hand.success'),
                message: translate('request.hand.thanks'),
                type: EPopupType.success,
              ),
            );
          },
        );
      }
    });

    on<SetRequestTypeEvent>(
      (final event, final emit) {
        if (state case final LoadedCreateRequestState st) {
          emit(
            st.copyWith(
              requestType: event.requestType,
            ),
          );
        }
      },
    );
  }
}
