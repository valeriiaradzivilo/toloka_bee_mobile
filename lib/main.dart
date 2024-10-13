import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'data/di.dart';
import 'features/main_screen/main_screen.dart';
import 'theme/theme.dart';
import 'theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final delegate = await LocalizationDelegate.create(fallbackLocale: 'en_US', supportedLocales: ['en_US']);

  await init();
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final TextTheme textTheme = ZipTheme.createTextTheme(context, 'Roboto Serif', 'Roboto');
    final MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: translate('app.name'),
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MainScreen(),
    );
  }
}
