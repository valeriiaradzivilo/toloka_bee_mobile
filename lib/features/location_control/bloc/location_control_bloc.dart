import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../common/constants/location_constants.dart';
import '../../../data/models/location_subscription_model.dart';
import '../../../data/service/fcm_service.dart';
import '../../../data/usecase/subscribe_to_topic_usecase.dart';

class LocationControlBloc extends ZipBloc {
  LocationControlBloc(final GetIt serviceLocator)
      : _subscribeToTopicUsecase = serviceLocator<SubscribeToTopicUsecase>(),
        super() {
    addSubscription(
      locationStream
          .debounceTime(const Duration(minutes: 1))
          .listen((final Position position) {
        if (FirebaseAuth.instance.currentUser == null) {
          return;
        }
        for (final location in position.locationTopicList) {
          _subscribeToTopicUsecase(
            LocationSubscriptionModel(
              id: '',
              topic: location,
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          );
        }
      }),
    );

    _init();
  }

  final locationStream = Geolocator.getPositionStream();
  final _permissionsGranted = BehaviorSubject.seeded(false);
  final SubscribeToTopicUsecase _subscribeToTopicUsecase;

  @override
  Future<void> dispose() async {
    await locationStream.drain();
    await _permissionsGranted.close();
    await super.dispose();
  }

  void _init() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      _permissionsGranted.add(false);
      return;
    }

    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      GetIt.instance.get<FcmService>().listenToMessages();
      GetIt.instance.get<FcmService>().listenToBackgroundMessages();
    } else {
      _permissionsGranted.add(false);
      return;
    }
  }
}
