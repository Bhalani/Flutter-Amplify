import 'package:flutter/material.dart';

class UIConstants {
  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS - Original teal-blue with indigo blend
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color primaryColor = Color.fromARGB(255, 4, 71, 100);
  static const Color primaryLightColor = Color.fromARGB(255, 180, 210, 220);
  static const Color primaryDarkColor = Color(0xFF02374E); // Original darker
  static const Color primarySurfaceColor =
      Color(0xFFE8F4F8); // Original light tint

  // ═══════════════════════════════════════════════════════════════════════════
  // 4 MAIN COLORS: Primary, Green, Red, Black (+Yellow for warnings)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color secondaryColor = Color(0xFFF8FAFC);
  static const Color accentColor = Color(0xFF059669); // Green - income
  static const Color accentSecondary = Color(0xFF059669); // Green - same
  static const Color warningColor =
      Color(0xFFD97706); // Yellow/Amber - optional
  static const Color dangerColor = Color(0xFFDC2626); // Red - expense/danger
  static const Color successColor = Color(0xFF059669); // Green - success/income

  // ═══════════════════════════════════════════════════════════════════════════
  // NEUTRAL COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color backgroundColor = Colors.white; // Fully white as requested
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white cards
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Color(0xFF0F172A); // Slate 900
  static const Color slateGreyColor = Color(0xFF475569); // Slate 600
  static const Color mutedColor = Color(0xFF94A3B8); // Slate 400
  static const Color borderLightGrey = Color(0xFFE2E8F0); // Slate 200
  static const Color dividerColor = Color(0xFFF1F5F9); // Slate 100

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDarkColor, primaryColor], // Original teal gradient
  );

  static const LinearGradient incomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)], // Green gradient
  );

  static const LinearGradient expenseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)], // Red gradient
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  // ============================================
  // SPACING SCALE (Material 3 - 4dp baseline grid)
  // ============================================
  static const double spaceXs = 4.0; // M3: extra-small
  static const double spaceSm = 8.0; // M3: small/compact
  static const double spaceMd = 16.0; // M3: medium/standard
  static const double spaceLg = 24.0; // M3: large/expanded
  static const double spaceXl = 32.0; // M3: extra-large
  static const double space2xl = 48.0; // M3: 2x-large

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS - M3 Expressive: Softer, more rounded corners
  // ═══════════════════════════════════════════════════════════════════════════
  static const double radiusXs = 4.0; // M3E: Reduced base
  static const double radiusSm = 8.0; // M3E: Reduced small
  static const double radiusMd = 12.0; // M3E: Reduced medium
  static const double radiusLg = 16.0; // M3E: Reduced cards
  static const double radiusXl = 24.0; // M3E: Reduced pills
  static const double radiusFull = 999.0; // Fully rounded (circles)

  static BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);
  // ============================================
  // SHADOWS (Material 3 Elevation Levels)
  // ============================================
  // Level 1 (1dp) - Cards at rest, subtle
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  // Level 2 (3dp) - Raised components
  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // Level 3 (6dp) - Floating elements, dialogs
  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 3,
      offset: const Offset(0, 2),
    ),
  ];

  // No colored shadows in M3 - using neutral elevation
  static List<BoxShadow> primaryShadow = shadowMd;

  // ============================================
  // ANIMATION DURATIONS
  // ============================================
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);

  // ============================================
  // BUTTON SIZES
  // ============================================
  static const Size largeButton = Size(double.infinity, 48);
  static const Size mediumButton = Size(200, 40);
  static const Size smallButton = Size(100, 32);

  // ============================================
  // TEXT SIZES & STYLES
  // ============================================
  static const double headerTextSize = 28.0;
  static const double subHeaderTextSize = 22.0;
  static const double titleTextSize = 18.0;
  static const double mediumTextSize = 16.0;
  static const double normalTextSize = 14.0;
  static const double smallTextSize = 12.0;
  static const double tinyTextSize = 10.0;

  static const TextStyle headingStyle = TextStyle(
    fontSize: headerTextSize,
    fontWeight: FontWeight.w700,
    color: blackColor,
    letterSpacing: -0.5,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: subHeaderTextSize,
    fontWeight: FontWeight.w600,
    color: blackColor,
    letterSpacing: -0.3,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: titleTextSize,
    fontWeight: FontWeight.w600,
    color: slateGreyColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: normalTextSize,
    fontWeight: FontWeight.w400,
    color: slateGreyColor,
    height: 1.5,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: smallTextSize,
    fontWeight: FontWeight.w500,
    color: mutedColor,
  );

  // ============================================
  // FORM STYLES (Material 3 - 56dp height)
  // ============================================
  static InputDecoration formInputDecoration = InputDecoration(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(color: borderLightGrey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(color: borderLightGrey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(color: dangerColor, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(color: dangerColor, width: 2),
    ),
    // M3: 56dp total height = 16dp top + 16dp bottom + ~24dp text
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  );

  // ============================================
  // CARD DECORATION
  // ============================================
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: borderRadiusLg,
    boxShadow: shadowSm,
  );

  static BoxDecoration primaryCardDecoration = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: borderRadiusLg,
    boxShadow: primaryShadow,
  );

  // ============================================
  // UTILITY METHODS
  // ============================================
  static String getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'CHF':
        return '₣';
      case 'SEK':
        return 'kr';
      case 'NOK':
        return 'kr';
      case 'DKK':
        return 'kr';
      case 'PLN':
        return 'zł';
      case 'CZK':
        return 'Kč';
      case 'HUF':
        return 'Ft';
      case 'RON':
        return 'lei';
      case 'HRK':
        return 'kn';
      case 'RSD':
        return 'дин';
      case 'BGN':
        return 'лв';
      case 'TRY':
        return '₺';
      default:
        return code;
    }
  }
}
