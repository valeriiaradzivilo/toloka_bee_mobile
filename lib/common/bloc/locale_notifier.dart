import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../features/main_app/main_app.dart';

class LocaleNotifier extends ChangeNotifier {
  static BuildContext? get _ctx => MainApp.navigatorKey.currentContext;
  Locale? _locale =
      _ctx != null ? LocalizedApp.of(_ctx!).delegate.currentLocale : null;

  Locale? get locale => _locale;

  Future<void> change(final String code) async {
    if (_ctx != null) {
      await changeLocale(_ctx!, code);
      _locale = Locale(code);
      notifyListeners();
    }
  }
}
