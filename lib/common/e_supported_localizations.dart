enum ESupportedLocalizations {
  en,
  ukr;

  static const Map<ESupportedLocalizations, String> names =
      <ESupportedLocalizations, String>{
    en: 'English',
    ukr: 'Українська',
  };
  static const Map<ESupportedLocalizations, String> codes =
      <ESupportedLocalizations, String>{
    en: 'en_US',
    ukr: 'uk',
  };
  static const Map<ESupportedLocalizations, String> flags =
      <ESupportedLocalizations, String>{
    en: '🇬🇧',
    ukr: '🇺🇦',
  };

  String get code => codes[this] ?? 'en_US';
  String get flag => flags[this] ?? '🇬🇧';
  String get text => names[this] ?? 'English';
}
