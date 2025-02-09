import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

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

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Text(
                translate('error.message'),
                style: const TextStyle(color: Colors.red),
              ),
              const Gap(8),
              Text(
                details.exceptionAsString(),
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  };
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
      },
      debugShowCheckedModeBanner: false,
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
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
          default:
            return MaterialPageRoute(builder: (context) => const MainScreen());
        }
      },
      builder: (context, child) {
        // Schedule the warning dialog after the first frame.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(translate('start.app.warning')),
              content: Text(translate('start.app.warning.message')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(translate('start.app.warning.accept')),
                ),
              ],
            ),
          );
        });
        return SafeArea(
          child: Stack(
            children: [
              if (child != null) child,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Assets.logo.logo.image(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
