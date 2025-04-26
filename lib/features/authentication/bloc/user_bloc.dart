import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../common/constants/location_constants.dart';
import '../../../common/exceptions/user_blocked_exception.dart';
import '../../../common/optional_value.dart';
import '../../../data/models/location_subscription_model.dart';
import '../../../data/models/ui/e_popup_type.dart';
import '../../../data/models/ui/popup_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/service/fcm_service.dart';
import '../../../data/usecase/subscribe_to_topic_usecase.dart';
import '../../../data/usecase/user_management/get_current_user_data_usecase.dart';
import '../../../data/usecase/user_management/login_user_usecase.dart';
import '../../../data/usecase/user_management/logout_user_usecase.dart';
import '../../registration/ui/data/e_position.dart';

class UserBloc extends ZipBloc {
  UserBloc(final GetIt locator)
      : _loginUserUsecase = locator<LoginUserUsecase>(),
        _getCurrentUserDataUsecase = locator<GetCurrentUserDataUsecase>(),
        _logoutUserUsecase = locator<LogoutUserUsecase>(),
        _subscribeToTopicUsecase = locator<SubscribeToTopicUsecase>(),
        _fcmService = locator<FcmService>() {
    _initAuth();
    _initLocationControl();

    addSubscription(
      _user.pairwise().listen((final users) async {
        if (users[1].valueOrNull?.bannedUntil != null &&
            users[1].valueOrNull!.bannedUntil!.isAfter(DateTime.now())) {
          await logout();
          _showBannedInfo(
            users[1].valueOrNull!.bannedUntil!,
          );
          return;
        }
        if (users[0].valueOrNull?.id == users[1].valueOrNull?.id) return;
        if (users[1].valueOrNull case OptionalValue<UserAuthModel>(:final value)
            when value.position.toLowerCase() ==
                EPosition.requester.name.toLowerCase()) {
          return;
        }

        locator<FcmService>().listenToMessages();
        locator<FcmService>().listenToBackgroundMessages();
      }),
    );

    addSubscription(
      FirebaseAuth.instance.authStateChanges().listen((final user) {
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
  }

  final BehaviorSubject<Optional<UserAuthModel>> _user =
      BehaviorSubject<Optional<UserAuthModel>>.seeded(const OptionalNull());
  final BehaviorSubject<PopupModel> _popupController =
      BehaviorSubject<PopupModel>();

  ValueStream<Optional<UserAuthModel>> get userStream => _user.stream;
  Stream<bool> get isAuthenticated =>
      userStream.map((final user) => user is OptionalValue);
  ValueStream<PopupModel> get authPopupStream => _popupController.stream;

  final LoginUserUsecase _loginUserUsecase;
  final GetCurrentUserDataUsecase _getCurrentUserDataUsecase;
  final LogoutUserUsecase _logoutUserUsecase;
  final SubscribeToTopicUsecase _subscribeToTopicUsecase;

  final FcmService _fcmService;

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
      'l' when kDebugMode => await _loginUserUsecase('lera@z.com', 'Lera1234!'),
      't' when kDebugMode =>
        await _loginUserUsecase('test@user.com', 'Lera1234!'),
      _ => await _loginUserUsecase(username, password),
    };

    return authResult.fold(
      (final error) {
        if (error case final UserBlockedException userBlockedException) {
          _showBannedInfo(userBlockedException.bannedUntil);
          //TODO: add support contact info
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

  @override
  Future<void> dispose() async {
    await _user.close();
    await _popupController.close();
    await super.dispose();
  }
}
