import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================
/// TASKFLOW DESIGN SYSTEM THEME
/// Dark mode default with dark red primary theme
/// Based on shadcn/ui patterns
/// ============================================================

/// ------------------------------------------------------------
/// TYPOGRAPHY SCALE
/// ------------------------------------------------------------
class AppTypography {
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 30.0;
}

/// ------------------------------------------------------------
/// SPACING SCALE (4px grid - matching Tailwind)
/// ------------------------------------------------------------
class AppSpacing {
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
}

/// ------------------------------------------------------------
/// BORDER RADIUS
/// ------------------------------------------------------------
class AppRadius {
  static const double radiusXs = 2.0; // checkbox
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0; // button, input, badge
  static const double radiusLg = 8.0; // dialog
  static const double radiusXl = 12.0; // card
  static const double radiusFull = 9999.0; // avatar, switch
}

/// ------------------------------------------------------------
/// COMPONENT SIZES
/// ------------------------------------------------------------
class AppSizes {
  // Button heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightDefault = 36.0;
  static const double buttonHeightLg = 40.0;

  // Input height
  static const double inputHeight = 36.0;

  // Avatar
  static const double avatarSize = 32.0;

  // Checkbox & Switch
  static const double checkboxSize = 16.0;
  static const double switchWidth = 32.0;
  static const double switchHeight = 18.0;
  static const double switchThumbSize = 16.0;

  // Icons
  static const double iconSizeSm = 16.0;
  static const double iconSizeDefault = 20.0;
  static const double iconSizeLg = 24.0;

  // Select/Dropdown height
  static const double selectHeight = 40.0;
}

/// ------------------------------------------------------------
/// SHADOWS
/// ------------------------------------------------------------
class AppShadows {
  static List<BoxShadow> get shadowXs => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
      ];
}

/// ------------------------------------------------------------
/// ANIMATION DURATIONS
/// ------------------------------------------------------------
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration dialog = Duration(milliseconds: 200);
}

/// ------------------------------------------------------------
/// BREAKPOINTS
/// ------------------------------------------------------------
class AppBreakpoints {
  static const double mobile = 768.0;
}

/// ------------------------------------------------------------
/// TEXT THEME (using Geist font via google_fonts)
/// ------------------------------------------------------------
TextTheme _buildTextTheme() {
  return TextTheme(
    // Display styles (largest headings)
    displayLarge: GoogleFonts.inter(
      fontSize: AppTypography.fontSize3xl,
      fontWeight: FontWeight.w700,
      color: foregroundColor,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppTypography.fontSize2xl,
      fontWeight: FontWeight.w700,
      color: foregroundColor,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),

    // Headline styles
    headlineLarge: GoogleFonts.inter(
      fontSize: AppTypography.fontSize2xl,
      fontWeight: FontWeight.w700,
      color: foregroundColor,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),

    // Title styles
    titleLarge: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeBase,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    ),

    // Body styles
    bodyLarge: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeBase,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: mutedForegroundColor,
    ),

    // Label styles
    labelLarge: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      color: mutedForegroundColor,
    ),
  );
}

/// ------------------------------------------------------------
/// MAIN THEME DATA
/// ------------------------------------------------------------
ThemeData theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundColor,

  // Color Scheme
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    primaryContainer: primaryColor,
    onPrimaryContainer: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    secondaryContainer: secondaryColor,
    onSecondaryContainer: onSecondaryColor,
    tertiary: accentColor,
    onTertiary: accentForegroundColor,
    error: errorColor,
    onError: onDestructiveColor,
    errorContainer: destructiveColor,
    onErrorContainer: onDestructiveColor,
    surface: cardColor,
    onSurface: foregroundColor,
    surfaceContainerHighest: cardColor,
    onSurfaceVariant: mutedForegroundColor,
    outline: borderColor,
    outlineVariant: borderColor,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: foregroundColor,
    onInverseSurface: backgroundColor,
    inversePrimary: primaryColor,
  ),

  // Text Theme
  textTheme: _buildTextTheme(),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),
    iconTheme: const IconThemeData(
      color: foregroundColor,
      size: AppSizes.iconSizeDefault,
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: cardColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: mutedForegroundColor,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),

  // Card Theme
  cardTheme: CardTheme(
    color: cardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusXl),
      side: const BorderSide(color: borderColor, width: 1),
    ),
    margin: EdgeInsets.zero,
  ),

  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      side: const BorderSide(color: borderColor, width: 1),
    ),
    titleTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
    ),
    contentTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
  ),

  // Elevated Button Theme (Default button variant)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      minimumSize: const Size(0, AppSizes.buttonHeightDefault),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      minimumSize: const Size(0, AppSizes.buttonHeightDefault),
      side: const BorderSide(color: borderColor, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Text Button Theme (Ghost button variant)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: foregroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      minimumSize: const Size(0, AppSizes.buttonHeightDefault),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space3,
      vertical: AppSpacing.space2,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      borderSide: const BorderSide(color: primaryColor, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      borderSide: const BorderSide(color: destructiveColor, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      borderSide: const BorderSide(color: destructiveColor, width: 1),
    ),
    hintStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: mutedForegroundColor,
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    ),
    errorStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: destructiveColor,
    ),
    constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
  ),

  // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(onPrimaryColor),
    side: const BorderSide(color: borderColor, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusXs),
    ),
    visualDensity: VisualDensity.compact,
  ),

  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return onPrimaryColor;
      }
      return foregroundColor;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return mutedColor;
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  // Chip Theme (for badges)
  chipTheme: ChipThemeData(
    backgroundColor: secondaryColor,
    labelStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: onSecondaryColor,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space2,
      vertical: AppSpacing.space1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
    ),
    side: BorderSide.none,
  ),

  // Tab Bar Theme
  tabBarTheme: TabBarTheme(
    labelColor: foregroundColor,
    unselectedLabelColor: mutedForegroundColor,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
    ),
  ),

  // Bottom Sheet Theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: backgroundColor,
    modalBackgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.radiusLg),
      ),
    ),
    elevation: 0,
  ),

  // Snackbar Theme (Toast)
  snackBarTheme: SnackBarThemeData(
    backgroundColor: cardColor,
    contentTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      side: const BorderSide(color: borderColor, width: 1),
    ),
    behavior: SnackBarBehavior.floating,
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: primaryColor,
    linearTrackColor: mutedColor,
    circularTrackColor: mutedColor,
  ),

  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: borderColor,
    thickness: 1,
    space: 1,
  ),

  // Icon Theme
  iconTheme: const IconThemeData(
    color: foregroundColor,
    size: AppSizes.iconSizeDefault,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: onPrimaryColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
    ),
  ),

  // Tooltip Theme
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      border: Border.all(color: borderColor),
    ),
    textStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
  ),

  // Popup Menu Theme
  popupMenuTheme: PopupMenuThemeData(
    color: cardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      side: const BorderSide(color: borderColor),
    ),
    textStyle: GoogleFonts.inter(
      fontSize: AppTypography.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: foregroundColor,
    ),
  ),

  // Dropdown Menu Theme
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: AppSpacing.space2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        borderSide: const BorderSide(color: primaryColor, width: 1),
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(cardColor),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd),
          side: const BorderSide(color: borderColor),
        ),
      ),
    ),
  ),

  // List Tile Theme
  listTileTheme: ListTileThemeData(
    tileColor: Colors.transparent,
    textColor: foregroundColor,
    iconColor: foregroundColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space4,
      vertical: AppSpacing.space2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
    ),
  ),
);
