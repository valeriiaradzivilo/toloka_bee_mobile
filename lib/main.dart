import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:zip_way/features/main_screen/main_screen.dart';

void main() async {
  final delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US']);

  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: translate('app.name'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
