import 'package:flutter/material.dart';

enum ZipFonts {
  big,
  medium,
  small;

  TextStyle get error => style.copyWith(color: Colors.red);

  TextStyle get style => switch (this) {
        big => const TextStyle(fontSize: 24),
        medium => const TextStyle(fontSize: 18),
        small => const TextStyle(fontSize: 12),
      };
}
