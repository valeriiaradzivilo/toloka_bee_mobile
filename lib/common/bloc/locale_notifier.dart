import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../main.dart';

class LocaleNotifier extends ChangeNotifier {
  static BuildContext? get _ctx => MyApp.navigatorKey.currentContext;
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
