import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

/// Custom tokens with no Material ColorScheme slot — paper reading surface,
/// highlighter color, and the quote-block callout. Accessed via
/// `Theme.of(context).extension<NotaColors>()!`.
@immutable
class NotaColors extends ThemeExtension<NotaColors> {
  const NotaColors({
    required this.canvas,
    required this.surface2,
    required this.paper,
    required this.paperText,
    required this.paperTextSecondary,
    required this.highlight,
    required this.highlightBg,
    required this.quoteBlockBg,
    required this.quoteBlockText,
  });

  final Color canvas;
  final Color surface2;
  final Color paper;
  final Color paperText;
  final Color paperTextSecondary;
  final Color highlight;
  final Color highlightBg;
  final Color quoteBlockBg;
  final Color quoteBlockText;

  static const dark = NotaColors(
    canvas: AppColorsDark.canvas,
    surface2: AppColorsDark.surface2,
    paper: AppColorsDark.paper,
    paperText: AppColorsDark.paperText,
    paperTextSecondary: AppColorsDark.paperTextSecondary,
    highlight: AppColorsDark.highlight,
    highlightBg: AppColorsDark.highlightBg,
    quoteBlockBg: AppColorsDark.quoteBlockBg,
    quoteBlockText: AppColorsDark.quoteBlockText,
  );

  static const light = NotaColors(
    canvas: AppColorsLight.canvas,
    surface2: AppColorsLight.surface2,
    paper: AppColorsLight.paper,
    paperText: AppColorsLight.paperText,
    paperTextSecondary: AppColorsLight.paperTextSecondary,
    highlight: AppColorsLight.highlight,
    highlightBg: AppColorsLight.highlightBg,
    quoteBlockBg: AppColorsLight.quoteBlockBg,
    quoteBlockText: AppColorsLight.quoteBlockText,
  );

  @override
  NotaColors copyWith({
    Color? canvas,
    Color? surface2,
    Color? paper,
    Color? paperText,
    Color? paperTextSecondary,
    Color? highlight,
    Color? highlightBg,
    Color? quoteBlockBg,
    Color? quoteBlockText,
  }) {
    return NotaColors(
      canvas: canvas ?? this.canvas,
      surface2: surface2 ?? this.surface2,
      paper: paper ?? this.paper,
      paperText: paperText ?? this.paperText,
      paperTextSecondary: paperTextSecondary ?? this.paperTextSecondary,
      highlight: highlight ?? this.highlight,
      highlightBg: highlightBg ?? this.highlightBg,
      quoteBlockBg: quoteBlockBg ?? this.quoteBlockBg,
      quoteBlockText: quoteBlockText ?? this.quoteBlockText,
    );
  }

  @override
  NotaColors lerp(ThemeExtension<NotaColors>? other, double t) {
    if (other is! NotaColors) return this;
    return NotaColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      paperText: Color.lerp(paperText, other.paperText, t)!,
      paperTextSecondary:
          Color.lerp(paperTextSecondary, other.paperTextSecondary, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      highlightBg: Color.lerp(highlightBg, other.highlightBg, t)!,
      quoteBlockBg: Color.lerp(quoteBlockBg, other.quoteBlockBg, t)!,
      quoteBlockText: Color.lerp(quoteBlockText, other.quoteBlockText, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    const scheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColorsDark.accent,
      onPrimary: Colors.white,
      secondary: AppColorsDark.accent,
      onSecondary: Colors.white,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      surfaceContainerHighest: AppColorsDark.surface2,
      onSurfaceVariant: AppColorsDark.textSecondary,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.border,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surfaceTint: Colors.transparent, // kill M3's auto blue-tint on elevated surfaces
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColorsDark.canvas,
      fontFamily: AppFonts.primary,
      extensions: const [NotaColors.dark],
      textTheme: _buildTextTheme(scheme.onSurface, scheme.onSurfaceVariant),
      dividerColor: AppColorsDark.border,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColorsDark.accent,
        selectionColor: AppColorsDark.accent.withValues(alpha: 0.3),
        selectionHandleColor: AppColorsDark.accent,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColorsDark.textPrimary),
      ),
      appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
      cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColorsDark.surface,
      ),
      dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
      popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Colors.transparent),
    );
  }

  static ThemeData get lightTheme {
    const scheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColorsLight.accent,
      onPrimary: Colors.white,
      secondary: AppColorsLight.accent,
      onSecondary: Colors.white,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.textPrimary,
      surfaceContainerHighest: AppColorsLight.surface2,
      onSurfaceVariant: AppColorsLight.textSecondary,
      outline: AppColorsLight.border,
      outlineVariant: AppColorsLight.border,
      error: Color(0xFFDC2626),
      onError: Colors.white,
      surfaceTint: Colors.transparent, // kill M3's auto blue-tint on elevated surfaces
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColorsLight.canvas,
      fontFamily: AppFonts.primary,
      extensions: const [NotaColors.light],
      textTheme: _buildTextTheme(scheme.onSurface, scheme.onSurfaceVariant),
      dividerColor: AppColorsLight.border,
      appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
      cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColorsLight.surface,
      ),
      dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
      popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Colors.transparent),
    );
  }

  static TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      titleLarge: AppTextStyles.screenTitle.copyWith(color: primaryText),
      labelSmall: AppTextStyles.eyebrow.copyWith(color: secondaryText),
      bodyLarge: AppTextStyles.body.copyWith(color: primaryText),
      bodySmall: AppTextStyles.meta.copyWith(color: secondaryText),
      labelLarge: AppTextStyles.label.copyWith(color: primaryText),
    );
  }
}

/// Usage in a widget:
///
/// final notaColors = Theme.of(context).extension<NotaColors>()!;
/// Container(color: notaColors.paper, child: Text('page content'));
///
/// final scheme = Theme.of(context).colorScheme;
/// Container(color: scheme.primary); // accent