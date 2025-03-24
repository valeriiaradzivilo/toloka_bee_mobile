import 'package:flutter/material.dart';

import 'zip_color.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() => const ColorScheme(
      brightness: Brightness.light,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
    );

  ThemeData light() => theme(lightScheme());

  static ColorScheme lightMediumContrastScheme() => const ColorScheme(
      brightness: Brightness.light,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
    );

  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());

  static ColorScheme lightHighContrastScheme() => const ColorScheme(
      brightness: Brightness.light,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
    );

  ThemeData lightHighContrast() => theme(lightHighContrastScheme());

  static ColorScheme darkScheme() => const ColorScheme(
      brightness: Brightness.dark,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
    );

  ThemeData dark() => theme(darkScheme());

  static ColorScheme darkMediumContrastScheme() => const ColorScheme(
      brightness: Brightness.dark,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
    );

  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());

  static ColorScheme darkHighContrastScheme() => const ColorScheme(
      brightness: Brightness.dark,
      primary: ZipColor.primary,
      surfaceTint: ZipColor.primary,
      onPrimary: ZipColor.onPrimary,
      primaryContainer: ZipColor.primaryContainer,
      onPrimaryContainer: ZipColor.onPrimaryContainer,
      secondary: ZipColor.secondary,
      onSecondary: ZipColor.onSecondary,
      secondaryContainer: ZipColor.secondaryContainer,
      onSecondaryContainer: ZipColor.onSecondaryContainer,
      tertiary: ZipColor.tertiary,
      onTertiary: ZipColor.onTertiary,
      tertiaryContainer: ZipColor.tertiaryContainer,
      onTertiaryContainer: ZipColor.onTertiaryContainer,
      error: ZipColor.error,
      onError: ZipColor.onError,
      errorContainer: ZipColor.errorContainer,
      onErrorContainer: ZipColor.onErrorContainer,
      surface: ZipColor.surface,
      onSurface: ZipColor.onSurface,
      onSurfaceVariant: ZipColor.onSurfaceVariant,
      outline: ZipColor.outline,
      outlineVariant: ZipColor.outlineVariant,
      shadow: ZipColor.shadow,
      scrim: ZipColor.scrim,
      inverseSurface: ZipColor.inverseSurface,
      inversePrimary: ZipColor.inversePrimary,
      primaryFixed: ZipColor.primaryFixed,
      onPrimaryFixed: ZipColor.onPrimaryFixed,
      primaryFixedDim: ZipColor.primaryFixedDim,
      onPrimaryFixedVariant: ZipColor.onPrimaryFixedVariant,
      secondaryFixed: ZipColor.secondaryFixed,
      onSecondaryFixed: ZipColor.onSecondaryFixed,
      secondaryFixedDim: ZipColor.secondaryFixedDim,
      onSecondaryFixedVariant: ZipColor.onSecondaryFixedVariant,
      tertiaryFixed: ZipColor.tertiaryFixed,
      onTertiaryFixed: ZipColor.onTertiaryFixed,
      tertiaryFixedDim: ZipColor.tertiaryFixedDim,
      onTertiaryFixedVariant: ZipColor.onTertiaryFixedVariant,
      surfaceDim: ZipColor.surfaceDim,
      surfaceBright: ZipColor.surfaceBright,
      surfaceContainerLowest: ZipColor.surfaceContainerLowest,
      surfaceContainerLow: ZipColor.surfaceContainerLow,
      surfaceContainer: ZipColor.surfaceContainer,
      surfaceContainerHigh: ZipColor.surfaceContainerHigh,
      surfaceContainerHighest: ZipColor.surfaceContainerHighest,
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
