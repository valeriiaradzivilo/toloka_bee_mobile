import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'common/widgets/error_screen.dart';
import 'data/di.dart';
import 'features/main_app/main_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const App());
}

class AppInitializer {
  static Future<void> initialize() async {
    _preserveSplash();
    await _initFirebase();
    await _initLocalization();
    await _initDependencies();
    await _initDateFormatting();
    _configureErrorHandling();
  }

  static void _preserveSplash() {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static LocalizationDelegate? _delegate;
  static Future<void> _initLocalization() async {
    _delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: const ['en_US', 'uk_UA'],
    );
  }

  static Future<void> _initDependencies() async {
    await init();
  }

  static Future<void> _initDateFormatting() async {
    final locale = PlatformDispatcher.instance.locale.languageCode;
    await initializeDateFormatting(locale);
    Intl.defaultLocale = locale;
  }

  static void _configureErrorHandling() {
    ErrorWidget.builder =
        (final FlutterErrorDetails details) => ErrorScreen(details);
  }

  static LocalizationDelegate get localizationDelegate {
    if (_delegate == null) {
      throw StateError('LocalizationDelegate is not initialized');
    }
    return _delegate!;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(final BuildContext context) => LocalizedApp(
        AppInitializer.localizationDelegate,
        const MainApp(),
      );
}
