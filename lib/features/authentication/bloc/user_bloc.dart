import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/bloc/toloka_bloc.dart';
import '../../../common/constants/location_constants.dart';
import '../../../common/exceptions/user_blocked_exception.dart';
import '../../../common/optional_value.dart';
import '../../../data/models/location_subscription_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/service/fcm_service.dart';
import '../../../data/service/snackbar_service.dart';
import '../../../data/usecase/requests/get_requests_by_user_id_usecase.dart';
import '../../../data/usecase/subscriptions/subscribe_to_location_topics_usecase.dart';
import '../../../data/usecase/subscriptions/subscribe_to_request_id_usecase.dart';
import '../../../data/usecase/user_management/get_current_user_data_usecase.dart';
import '../../../data/usecase/user_management/login_user_usecase.dart';
import '../../../data/usecase/user_management/logout_user_usecase.dart';
import '../../../data/usecase/volunteer_work/get_volunteer_work_by_user_id_usecase.dart';
import '../../registration/ui/data/e_position.dart';

const _testPassword = 'Lera1234!';

class UserBloc extends TolokaBloc {
  UserBloc(final GetIt locator)
      : _loginUserUsecase = locator<LoginUserUsecase>(),
        _getCurrentUserDataUsecase = locator<GetCurrentUserDataUsecase>(),
        _getRequestsByUserIdUsecase = locator<GetRequestsByUserIdUsecase>(),
        _getVolunteerWorksByUserIdUsecase =
            locator<GetVolunteerWorksByUserIdUsecase>(),
        _logoutUserUsecase = locator<LogoutUserUsecase>(),
        _subscribeToTopicUsecase = locator<SubscribeToLocationTopicsUsecase>(),
        _subscribeToRequestIdUsecase = locator<SubscribeToRequestIdUsecase>(),
        _fcmService = locator<FcmService>(),
        _snackbar = locator<SnackbarService>() {
    _initAuth();
    _initLocationControl();

    addSubscription(
      _user.pairwise().listen((final users) async {
        if (users[0].valueOrNull == users[1].valueOrNull) return;

        if (users[1].valueOrNull?.bannedUntil != null &&
            users[1].valueOrNull!.bannedUntil!.isAfter(DateTime.now())) {
          await logout();
          _showBannedInfo(
            users[1].valueOrNull!.bannedUntil!,
          );
          return;
        }

        if (users[1].valueOrNull == null &&
            FirebaseAuth.instance.currentUser != null) {
          await logout();
          return;
        }

        final requestsResult = await _getRequestsByUserIdUsecase.call(
          users[1].valueOrNull?.id ?? '',
        );

        requestsResult.fold((final _) {}, (final requests) {
          for (final request in requests) {
            if (request.status.canBeHelped &&
                request.deadline.isAfter(DateTime.now()) &&
                !_subscribedToTopics.contains(request.id)) {
              _subscribeToRequestIdUsecase.call(request.id);
            }
          }
        });

        final volunteerWorksResult =
            await _getVolunteerWorksByUserIdUsecase.call(
          users[1].valueOrNull?.id ?? '',
        );

        volunteerWorksResult.fold((final _) {}, (final volunteerWorks) {
          for (final volunteerWork in volunteerWorks) {
            if (!volunteerWork.requesterConfirmed &&
                !_subscribedToTopics.contains(volunteerWork.requestId)) {
              _subscribeToRequestIdUsecase.call(volunteerWork.requestId);
            }
          }
        });
      }),
    );

    addSubscription(
      FirebaseAuth.instance.authStateChanges().listen((final user) {
        if (user == null && _user.valueOrNull == null) {
          return;
        }

        if (user == null) {
          _user.add(const OptionalNull());
          return;
        }
        _getCurrentUserDataUsecase.call().then((final result) {
          result.fold(
            (final error) => _user.add(const OptionalNull()),
            (final user) => _user.add(OptionalValue(user)),
          );
        });
      }),
    );
    addSubscription(
      Stream.periodic(const Duration(seconds: 120)).listen((final _) {
        _getCurrentUserDataUsecase.call().then((final result) {
          result.fold(
            (final error) => _user.add(const OptionalNull()),
            (final user) => _user.add(OptionalValue(user)),
          );
        });
      }),
    );

    addSubscription(
      authPopupStream.listen((final popup) {
        _snackbar.show(popup);
      }),
    );
  }

  ValueStream<Optional<UserAuthModel>> get userStream => _user.stream;
  Stream<bool> get isAuthenticated =>
      userStream.map((final user) => user is OptionalValue);
  ValueStream<PopupModel> get authPopupStream => _popupController.stream;

  final locationStream = Geolocator.getPositionStream();
  bool isFirstRun = true;

  Future<void> _initAuth() async {
    final result = await _getCurrentUserDataUsecase.call();
    result.fold((final _) {
      _user.add(const OptionalNull());
    }, (final user) {
      _user.add(OptionalValue(user));
    });
  }

  Future<bool> login(final String username, final String password) async {
    final authResult = switch (username) {
      'l' when kDebugMode =>
        await _loginUserUsecase('lera@z.com', _testPassword),
      't' when kDebugMode =>
        await _loginUserUsecase('test@user.com', _testPassword),
      's' when kDebugMode =>
        await _loginUserUsecase('sofiia@gmail.com', _testPassword),
      'r' when kDebugMode =>
        await _loginUserUsecase('requester@gmail.com', _testPassword),
      _ => await _loginUserUsecase(username, password),
    };

    return authResult.fold(
      (final error) {
        if (error case final UserBlockedException userBlockedException) {
          _showBannedInfo(userBlockedException.bannedUntil);
          return false;
        }

        _popupController.add(
          PopupModel(
            title: translate('login.unable'),
            message: translate('login.error'),
            type: EPopupType.error,
          ),
        );
        return false;
      },
      (final user) {
        _user.add(OptionalValue(user));
        _popupController.add(
          PopupModel(
            title: translate('login.success'),
            message: translate('login.welcome', args: {'name': user.name}),
            type: EPopupType.success,
          ),
        );
        return true;
      },
    );
  }

  void _showBannedInfo(final DateTime bannedUntil) {
    _popupController.add(
      PopupModel(
        title: translate('login.unable'),
        message: translate(
          'login.banned',
          args: {
            'date': DateFormat.yMMMMEEEEd().format(bannedUntil),
          },
        ),
        type: EPopupType.error,
      ),
    );
    _fcmService.showLocalNotification(
      title: translate('login.banned'),
      body: translate('login.banned_info'),
    );
  }

  Future<void> logout() async {
    final result = await _logoutUserUsecase.call();
    _fcmService.stopListeningToMessages();
    result.fold(
      (final error) {},
      (final _) {
        _popupController.add(
          PopupModel(
            title: translate('logout.success'),
            message: translate('logout.subtitle'),
            type: EPopupType.success,
          ),
        );
      },
    );
  }

  void _initLocationControl() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return;
    }

    final settings = await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      addSubscription(
        Rx.combineLatest2(
          locationStream,
          userStream,
          (final location, final user) => (location: location, user: user),
        )
            .debounceTime(const Duration(seconds: 1))
            .pairwise()
            .listen((final data) {
          final userNew = data[1].user;
          if (userNew is OptionalNull) return;
          if (userNew case OptionalValue(:final value)
              when value.position.toLowerCase() ==
                  EPosition.requester.name.toLowerCase()) {
            return;
          }
          final prev = data[0].location;
          final curr = data[1].location;
          if (!isFirstRun &&
              prev.latitude == curr.latitude &&
              prev.longitude == curr.longitude) {
            return;
          }

          final topics = curr.locationTopicList;
          _subscribeToTopicUsecase(
            topics
                .map(
                  (final topic) => LocationSubscriptionModel(
                    id: '',
                    topic: topic,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  ),
                )
                .toList(),
          );
          isFirstRun = false;
        }),
      );
    }
  }

  void updateUser() async {
    final user = await _getCurrentUserDataUsecase.call();
    user.fold((final _) {}, (final user) {
      _user.add(OptionalValue(user));
    });
  }

  final LoginUserUsecase _loginUserUsecase;
  final GetCurrentUserDataUsecase _getCurrentUserDataUsecase;
  final GetRequestsByUserIdUsecase _getRequestsByUserIdUsecase;
  final GetVolunteerWorksByUserIdUsecase _getVolunteerWorksByUserIdUsecase;
  final SubscribeToRequestIdUsecase _subscribeToRequestIdUsecase;
  final LogoutUserUsecase _logoutUserUsecase;
  final SubscribeToLocationTopicsUsecase _subscribeToTopicUsecase;

  final FcmService _fcmService;
  final SnackbarService _snackbar;

  final BehaviorSubject<Optional<UserAuthModel>> _user =
      BehaviorSubject<Optional<UserAuthModel>>.seeded(const OptionalNull());
  final BehaviorSubject<PopupModel> _popupController =
      BehaviorSubject<PopupModel>();
  final List<String> _subscribedToTopics = [];

  @override
  Future<void> dispose() async {
    await _user.close();
    await _popupController.close();
    await super.dispose();
  }
}
