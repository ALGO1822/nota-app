import 'package:flutter/material.dart';

/// Nota design tokens — dark-first, with light mode as a derived variant.
/// Pull these into your MVVM theme layer / a ThemeData builder rather than
/// referencing raw values in widgets.

// ---------------------------------------------------------------------------
// COLORS
// ---------------------------------------------------------------------------

class AppColorsDark {
  AppColorsDark._();

  static const canvas = Color(0xFF101010);
  static const surface = Color(0xFF181818);
  static const surface2 = Color(0xFF202020);
  static const border = Color(0xFF282828);
  
  static const textPrimary = Color(0xFFF2F2F3);
  static const textSecondary = Color(0xFF8B8D91);
  static const accent = Color(0xFF6366F1);
  static const accentDim = Color(0x336366F1);

  // Reading surface — identical in both themes, do not swap per-theme
  static const paper = Color(0xFFF7F5F0);
  static const paperText = Color(0xFF22201B);
  static const paperTextSecondary = Color(0xFF6B675F);

  static const highlight = Color(0xFFF3C969);
  static const highlightBg = Color(0x55F3C969); 
  static const quoteBlockBg = Color(0xFF1F1B12);
  static const quoteBlockText = Color(0xFFD8CFC0);
}

class AppColorsLight {
  AppColorsLight._();

  static const canvas = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF2F2F3);
  static const border = Color(0xFFE5E5E5);

  static const textPrimary = Color(0xFF171717);
  static const textSecondary = Color(0xFF6B7280);

  static const accent = Color(0xFF4F46E5);
  static const accentDim = Color(0x334F46E5); // 20% alpha

  // Reading surface — identical in both themes, do not swap per-theme
  static const paper = Color(0xFFF7F5F0);
  static const paperText = Color(0xFF22201B);
  static const paperTextSecondary = Color(0xFF6B675F);

  static const highlight = Color(0xFFF3C969);
  static const highlightBg = Color(0x88F3C969); // ~53% alpha

  static const quoteBlockBg = Color(0xFFFDF6E3);
  static const quoteBlockText = Color(0xFF6B5E3C);
}

// ---------------------------------------------------------------------------
// SPACING
// ---------------------------------------------------------------------------

/// Base unit: 4px. Use these steps everywhere — do not hardcode arbitrary
/// padding/margin values in widgets.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

// ---------------------------------------------------------------------------
// RADIUS
// ---------------------------------------------------------------------------

class AppRadius {
  AppRadius._();

  static const double sm = 6; // most elements: rows, nodes, inputs
  static const double lg = 12; // sheets, modals, larger surfaces
  static const double pill = 999; // FAB, app bar capsule, tags, tabs

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}

// ---------------------------------------------------------------------------
// BORDERS
// ---------------------------------------------------------------------------

class AppBorders {
  AppBorders._();

  static const double hairline = 1;
  static const double iconStroke = 1.5;
  static const double connectorStroke = 1.5;
}

// ---------------------------------------------------------------------------
// TYPOGRAPHY
// ---------------------------------------------------------------------------

/// Font family name — register this to match whatever you name the Inter
/// Variable / static TTF assets in pubspec.yaml.
class AppFonts {
  AppFonts._();

  static const String primary = 'Inter';

  // Weights used across the app — do not introduce weights outside this set.
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500; // stand-in for the 510 variable-weight value
  static const FontWeight semibold = FontWeight.w600;
}

/// Text styles built off the type scale from the design mockup.
/// Pass a `TextTheme`-building function per theme if colors need to differ;
/// these base styles are color-agnostic — apply color via `.copyWith(color: ...)`
/// or through your ThemeData's colorScheme mapping.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 20,
    fontWeight: AppFonts.semibold,
    height: 1.3,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: AppFonts.medium,
    letterSpacing: 0.9, // wide tracking, ~0.075em at 12px
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: AppFonts.regular,
    height: 1.6,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 13,
    fontWeight: AppFonts.regular,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: AppFonts.medium,
    height: 1.4,
  );

  static const TextStyle diagramNode = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 11,
    fontWeight: AppFonts.medium,
    height: 1.3,
  );

  static const TextStyle diagramNodeSub = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 9.5,
    fontWeight: AppFonts.regular,
    height: 1.3,
  );
}

// ---------------------------------------------------------------------------
// ELEVATION / SHADOWS
// ---------------------------------------------------------------------------

class AppShadows {
  AppShadows._();

  // Soft, close-range shadow for bottom sheets/modals — the only shadow
  // type permitted outside the app bar and FAB.
  static List<BoxShadow> sheet(Color base) => [
        BoxShadow(
          color: base.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, -8),
        ),
      ];

  static List<BoxShadow> appBar(Color base) => [
        BoxShadow(
          color: base.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -6,
        ),
      ];

  static List<BoxShadow> fab(Color accent) => [
        BoxShadow(
          color: accent.withValues(alpha: 0.45),
          blurRadius: 30,
          offset: const Offset(0, 8),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: accent.withValues(alpha: 0.35),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
      ];
}

// ---------------------------------------------------------------------------
// TOUCH TARGETS
// ---------------------------------------------------------------------------

class AppSizing {
  AppSizing._();

  static const double minTouchTarget = 44;
  static const double iconButtonSm = 30; // app bar icon buttons
  static const double iconButtonMd = 36; // diagram toolbar buttons
  static const double fabSize = 65;
  static const double appBarHeight = 60;
}