import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

const String fontFamily = 'Inter';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onPrimaryColor,
    error: errorColor,
    onError: onPrimaryColor,
    surface: backgroundColor,
    onSurface: textColor,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      color: blackColor,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      color: blackColor,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      color: blackColor,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      color: blackColor,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      color: blackColor,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      color: blackColor,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      color: blackColor,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      color: blackColor,
    ),
  ),
  useMaterial3: true,
);
