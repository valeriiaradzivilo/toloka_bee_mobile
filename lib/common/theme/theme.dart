import 'package:flutter/material.dart';

import 'toloka_color.dart';
import 'toloka_fonts.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData light() => theme(lightScheme());

  static ColorScheme lightMediumContrastScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());

  static ColorScheme lightHighContrastScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData lightHighContrast() => theme(lightHighContrastScheme());

  static ColorScheme darkScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData dark() => theme(darkScheme());

  static ColorScheme darkMediumContrastScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());

  static ColorScheme darkHighContrastScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: TolokaColor.primary,
        surfaceTint: TolokaColor.primary,
        onPrimary: TolokaColor.onPrimary,
        primaryContainer: TolokaColor.primaryContainer,
        onPrimaryContainer: TolokaColor.onPrimaryContainer,
        secondary: TolokaColor.secondary,
        onSecondary: TolokaColor.onSecondary,
        secondaryContainer: TolokaColor.secondaryContainer,
        onSecondaryContainer: TolokaColor.onSecondaryContainer,
        tertiary: TolokaColor.tertiary,
        onTertiary: TolokaColor.onTertiary,
        tertiaryContainer: TolokaColor.tertiaryContainer,
        onTertiaryContainer: TolokaColor.onTertiaryContainer,
        error: TolokaColor.error,
        onError: TolokaColor.onError,
        errorContainer: TolokaColor.errorContainer,
        onErrorContainer: TolokaColor.onErrorContainer,
        surface: TolokaColor.surface,
        onSurface: TolokaColor.onSurface,
        onSurfaceVariant: TolokaColor.onSurfaceVariant,
        outline: TolokaColor.outline,
        outlineVariant: TolokaColor.outlineVariant,
        shadow: TolokaColor.shadow,
        scrim: TolokaColor.scrim,
        inverseSurface: TolokaColor.inverseSurface,
        inversePrimary: TolokaColor.inversePrimary,
        primaryFixed: TolokaColor.primaryFixed,
        onPrimaryFixed: TolokaColor.onPrimaryFixed,
        primaryFixedDim: TolokaColor.primaryFixedDim,
        onPrimaryFixedVariant: TolokaColor.onPrimaryFixedVariant,
        secondaryFixed: TolokaColor.secondaryFixed,
        onSecondaryFixed: TolokaColor.onSecondaryFixed,
        secondaryFixedDim: TolokaColor.secondaryFixedDim,
        onSecondaryFixedVariant: TolokaColor.onSecondaryFixedVariant,
        tertiaryFixed: TolokaColor.tertiaryFixed,
        onTertiaryFixed: TolokaColor.onTertiaryFixed,
        tertiaryFixedDim: TolokaColor.tertiaryFixedDim,
        onTertiaryFixedVariant: TolokaColor.onTertiaryFixedVariant,
        surfaceDim: TolokaColor.surfaceDim,
        surfaceBright: TolokaColor.surfaceBright,
        surfaceContainerLowest: TolokaColor.surfaceContainerLowest,
        surfaceContainerLow: TolokaColor.surfaceContainerLow,
        surfaceContainer: TolokaColor.surfaceContainer,
        surfaceContainerHigh: TolokaColor.surfaceContainerHigh,
        surfaceContainerHighest: TolokaColor.surfaceContainerHighest,
      );

  ThemeData darkHighContrast() => theme(darkHighContrastScheme());

  ThemeData theme(final ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((final state) {
              if (state.contains(WidgetState.disabled)) {
                return colorScheme.surfaceContainerLow;
              }
              return colorScheme.primary;
            }),
            foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
            iconSize: WidgetStateProperty.all(24),
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(colorScheme.onSurface),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle:
              TolokaFonts.medium.style.copyWith(color: Colors.black),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
