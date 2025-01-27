import 'dart:ui';

class ZipColor {
  static const primary = Color(0xff006a60);
  static const onPrimary = Color(0xffffffff);
  static const primaryContainer = Color(0xff48d6c3);
  static const onPrimaryContainer = Color(0xff003a33);
  static const secondary = Color(0xff38665f);
  static const onSecondary = Color(0xffffffff);
  static const secondaryContainer = Color(0xffbdeee4);
  static const onSecondaryContainer = Color(0xff21514a);
  static const tertiary = Color(0xff6a509e);
  static const onTertiary = Color(0xffffffff);
  static const tertiaryContainer = Color(0xffceb4ff);
  static const onTertiaryContainer = Color(0xff3c216e);
  static const error = Color(0xffba1a1a);
  static const onError = Color(0xffffffff);
  static const errorContainer = Color(0xffffdad6);
  static const onErrorContainer = Color(0xff410002);
  static const surface = Color(0xfff4fbf8);
  static const onSurface = Color(0xff161d1b);
  static const onSurfaceVariant = Color(0xff3c4947);
  static const outline = Color(0xff6c7a77);
  static const outlineVariant = Color(0xffbbcac6);
  static const shadow = Color(0xff000000);
  static const scrim = Color(0xff000000);
  static const inverseSurface = Color(0xff2b3230);
  static const inversePrimary = Color(0xff4fdbc9);
  static const primaryFixed = Color(0xff70f8e5);
  static const onPrimaryFixed = Color(0xff00201c);
  static const primaryFixedDim = Color(0xff4fdbc9);
  static const onPrimaryFixedVariant = Color(0xff005048);
  static const secondaryFixed = Color(0xffbbece3);
  static const onSecondaryFixed = Color(0xff00201c);
  static const secondaryFixedDim = Color(0xffa0d0c7);
  static const onSecondaryFixedVariant = Color(0xff1f4e48);
  static const tertiaryFixed = Color(0xffebddff);
  static const onTertiaryFixed = Color(0xff250257);
  static const tertiaryFixedDim = Color(0xffd3bbff);
  static const onTertiaryFixedVariant = Color(0xff523784);
  static const surfaceDim = Color(0xffd5dbd9);
  static const surfaceBright = Color(0xfff4fbf8);
  static const surfaceContainerLowest = Color(0xffffffff);
  static const surfaceContainerLow = Color(0xffeef5f2);
  static const surfaceContainer = Color(0xffe9efed);
  static const surfaceContainerHigh = Color(0xffe3eae7);
  static const surfaceContainerHighest = Color(0xffdde4e1);

  static final Color randomZipColor = [
    primary,
    onSecondaryFixed,
    onPrimaryContainer,
    onErrorContainer,
    secondary,
    tertiary
  ].elementAt(DateTime.now().microsecond % 6);
}
