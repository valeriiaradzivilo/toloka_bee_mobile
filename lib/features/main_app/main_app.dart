import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../common/bloc/locale_notifier.dart';
import '../../common/routing/route_generator.dart';
import '../../common/routing/routes.dart';
import '../../common/theme/theme.dart';
import '../../common/theme/toloka_theme.dart';
import '../authentication/bloc/user_bloc.dart';
import 'main_wrapper_widget.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  Widget build(final BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme =
        TolokaTheme.createTextTheme(context, 'Roboto Serif', 'Roboto');
    final theme = MaterialTheme(textTheme);

    FlutterNativeSplash.remove();

    return MultiProvider(
      providers: [
        Provider(
          create: (final _) => UserBloc(GetIt.I),
          dispose: (final _, final bloc) => bloc.dispose(),
        ),
        ChangeNotifierProvider(create: (final _) => LocaleNotifier()),
      ],
      child: MaterialApp(
        title: translate('app.name'),
        navigatorKey: navigatorKey,
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        darkTheme: theme.dark(),
        initialRoute: Routes.mainScreen,
        onGenerateRoute: RouteGenerator.generate,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        builder: (final context, final child) => MainWrapperWidget(child),
      ),
    );
  }
}
