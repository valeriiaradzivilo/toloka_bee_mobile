class Country {
  final String name;
  final String code;
  final String dialCode;
  final String emojiFlag;

  Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.emojiFlag,
  });

  factory Country.fromJson(final Map<String, dynamic> json) {
    final root = json['idd']['root'] as String? ?? '';
    final suffixes = (json['idd']['suffixes'] as List?);
    final suffix = suffixes?.isNotEmpty == true ? suffixes!.first : '';
    final dial = '$root$suffix';
    final iso = json['cca2'] as String;
    final flagEmoji = iso
        .toUpperCase()
        .codeUnits
        .map((final c) => String.fromCharCode(0x1F1E6 + c - 65))
        .join();
    return Country(
      name: json['name']['common'] as String,
      code: iso,
      dialCode: dial,
      emojiFlag: flagEmoji,
    );
  }
}
