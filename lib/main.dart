import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'common/routes.dart';
import 'common/theme/theme.dart';
import 'common/theme/util.dart';
import 'data/di.dart';
import 'data/usecase/authenticate_user_usecase.dart';
import 'features/authentication/ui/create_account_screen.dart';
import 'features/authentication/ui/login_screen.dart';
import 'features/main_screen/main_screen.dart';
import 'features/profile/ui/profile_screen.dart';
import 'gen/assets.gen.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US']);

  await init();
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final TextTheme textTheme =
        ZipTheme.createTextTheme(context, 'Roboto Serif', 'Roboto');
    final MaterialTheme theme = MaterialTheme(textTheme);

    FlutterNativeSplash.remove();

    return MaterialApp(
      title: translate('app.name'),
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      initialRoute: Routes.mainScreen,
      routes: {
        Routes.mainScreen: (context) => const MainScreen(),
        Routes.loginScreen: (context) => const LoginScreen(),
        Routes.createAccountScreen: (context) => const CreateAccountScreen(),
        // Routes.profileScreen: (context) => const ProfileScreen(),
        // Routes.requestsScreen: (context) => const RequestsScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.loginScreen:
            serviceLocator.registerLazySingleton<AuthenticateUserUsecase>(
                () => AuthenticateUserUsecase());
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case Routes.createAccountScreen:
            serviceLocator.registerLazySingleton<AuthenticateUserUsecase>(
                () => AuthenticateUserUsecase());
            return MaterialPageRoute(
                builder: (context) => const CreateAccountScreen());
          case Routes.profileScreen:
            return MaterialPageRoute(
                builder: (context) => const ProfileScreen());
          // case Routes.requestsScreen:
          //   return MaterialPageRoute(builder: (context) => const RequestsScreen());
          default:
            return MaterialPageRoute(builder: (context) => const MainScreen());
        }
      },
      builder: (context, child) => SafeArea(
        child: Stack(
          children: [
            child!,
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: Assets.logo.logo.image(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
