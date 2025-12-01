import 'package:flutter/material.dart';

/// ============================================================
/// TASKFLOW DESIGN SYSTEM - DARK MODE (DEFAULT)
/// Based on shadcn/ui patterns with dark red primary theme
/// ============================================================

/// ------------------------------------------------------------
/// CORE COLORS (Dark Mode)
/// ------------------------------------------------------------
const Color backgroundColor = Color(0xFF1F1F1F);
const Color foregroundColor = Color(0xFFF2F2F2);
const Color cardColor = Color(0xFF262626);
const Color cardForegroundColor = Color(0xFFF2F2F2);

/// ------------------------------------------------------------
/// BRAND / PRIMARY COLORS
/// ------------------------------------------------------------
const Color primaryColor = Color(0xFFA93535);
const Color onPrimaryColor = Color(0xFFFAFAFA);

/// ------------------------------------------------------------
/// SECONDARY COLORS
/// ------------------------------------------------------------
const Color secondaryColor = Color(0xFF333333);
const Color onSecondaryColor = Color(0xFFF2F2F2);

/// ------------------------------------------------------------
/// MUTED COLORS
/// ------------------------------------------------------------
const Color mutedColor = Color(0xFF333333);
const Color mutedForegroundColor = Color(0xFFA3A3A3);

/// ------------------------------------------------------------
/// ACCENT COLORS
/// ------------------------------------------------------------
const Color accentColor = Color(0xFF333333);
const Color accentForegroundColor = Color(0xFFF2F2F2);

/// ------------------------------------------------------------
/// DESTRUCTIVE / ERROR COLORS
/// ------------------------------------------------------------
const Color destructiveColor = Color(0xFF991B1B);
const Color onDestructiveColor = Color(0xFFFAFAFA);
const Color errorColor = Color(0xFF991B1B);

/// ------------------------------------------------------------
/// BORDER & INPUT COLORS
/// ------------------------------------------------------------
const Color borderColor = Color(0xFF404040);
const Color inputColor = Color(0xFF404040);
const Color ringColor = Color(0xFFA93535);

/// ------------------------------------------------------------
/// PRIORITY COLORS (for task badges)
/// ------------------------------------------------------------
const Color priorityLowColor = Color(0xFF3B82F6);
const Color priorityMediumColor = Color(0xFFEAB308);
const Color priorityHighColor = Color(0xFFEF4444);

/// Priority badge backgrounds (10% opacity versions)
Color get priorityLowBgColor => priorityLowColor.withOpacity(0.1);
Color get priorityMediumBgColor => priorityMediumColor.withOpacity(0.1);
Color get priorityHighBgColor => priorityHighColor.withOpacity(0.1);

/// ------------------------------------------------------------
/// STATUS COLORS (for task status badges - dark mode adapted)
/// ------------------------------------------------------------
/// In progress - Green tones
const Color inProgressColor = Color(0xFF16A34A);
const Color inProgressBgColor = Color(0xFF1A3D2A);
const Color onInProgressColor = Color(0xFF4ADE80);

/// On hold - Grey tones
const Color onHoldColor = Color(0xFF404040);
const Color onHoldBgColor = Color(0xFF333333);
const Color onOnHoldColor = Color(0xFFA3A3A3);

/// Pending - Orange tones
const Color pendingColor = Color(0xFFEA580C);
const Color pendingBgColor = Color(0xFF3D2A1A);
const Color onPendingColor = Color(0xFFFB923C);

/// Finished - Blue tones
const Color finishedColor = Color(0xFF2563EB);
const Color finishedBgColor = Color(0xFF1A2A3D);
const Color onFinishedColor = Color(0xFF60A5FA);

/// Validated - Same as in progress
const Color validatedColor = Color(0xFF16A34A);
const Color validatedBgColor = Color(0xFF1A3D2A);
const Color onValidatedColor = Color(0xFF4ADE80);

/// ------------------------------------------------------------
/// CHART / DATA VISUALIZATION COLORS
/// ------------------------------------------------------------
const Color chartColor1 = Color(0xFFA93535);
const Color chartColor2 = Color(0xFF3B82F6);
const Color chartColor3 = Color(0xFF16A34A);
const Color chartColor4 = Color(0xFFEAB308);
const Color chartColor5 = Color(0xFF8B5CF6);

/// ------------------------------------------------------------
/// UI COMPONENT COLORS
/// ------------------------------------------------------------
const Color unselectedButtonNavbarColor = Color(0xFFA3A3A3);
const Color selectedButtonNavbarColor = Color(0xFFA93535);

/// Button variants
const Color buttonDefaultBgColor = Color(0xFFA93535);
const Color buttonDefaultFgColor = Color(0xFFFAFAFA);
const Color buttonDestructiveBgColor = Color(0xFF991B1B);
const Color buttonDestructiveFgColor = Color(0xFFFAFAFA);
const Color buttonSecondaryBgColor = Color(0xFF333333);
const Color buttonSecondaryFgColor = Color(0xFFF2F2F2);
const Color buttonOutlineBorderColor = Color(0xFF404040);
const Color buttonOutlineFgColor = Color(0xFFF2F2F2);
const Color buttonGhostFgColor = Color(0xFFF2F2F2);

/// Success / Green actions
const Color successColor = Color(0xFF16A34A);
const Color greenButtonColor = Color(0xFF16A34A);
const Color redButtonColor = Color(0xFFEF4444);

/// ------------------------------------------------------------
/// OVERLAY
/// ------------------------------------------------------------
Color get overlayColor => Colors.black.withOpacity(0.5);

/// ------------------------------------------------------------
/// LEGACY COMPATIBILITY ALIASES
/// (Mapping old color names to new design system)
/// ------------------------------------------------------------
const Color textColor = foregroundColor;
const Color greyTextColor = mutedForegroundColor;
const Color redTextColor = Color(0xFFEF4444);
const Color lightGreyColor = borderColor;
const Color borderLightGreyColor = borderColor;
const Color mediumGreyColor = mutedForegroundColor;
const Color whiteColor = Color(0xFFFAFAFA);
const Color blackColor = Color(0xFF1F1F1F);
const Color lightBlue = Color(0xFF3B82F6);
const Color onLightBlue = Color(0xFF60A5FA);
const Color orangeColor = Color(0xFFEAB308);
const Color surfaceLightBlue = finishedBgColor;
const Color onSurfaceLightBlue = onFinishedColor;
const Color onBackgroundColor = foregroundColor;

/// New design system foreground aliases
const Color primaryForegroundColor = onPrimaryColor;
const Color secondaryForegroundColor = onSecondaryColor;
const Color destructiveForegroundColor = onDestructiveColor;

/// Chart colors list for data visualization
const List<Color> chartColors = [
  chartColor1,
  chartColor2,
  chartColor3,
  chartColor4,
  chartColor5,
];
