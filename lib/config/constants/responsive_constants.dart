import 'package:flutter/material.dart';

/// Constants for responsive sizing based on Figma design
class ResponsiveConstants {
  // Base dimensions from Figma design (iPhone 13 and 14 size Screen)
  static const double figmaBaseWidth = 390;
  static const double figmaBaseHeight = 844;

  /// Calculate relative width based on Figma dimensions
  static double getRelativeWidth(BuildContext context, double figmaWidth) {
    final width = MediaQuery.of(context).size.width;
    return (figmaWidth / figmaBaseWidth) * width;
  }

  /// Calculate relative height based on Figma dimensions
  static double getRelativeHeight(BuildContext context, double figmaHeight) {
    final height = MediaQuery.of(context).size.height;
    return (figmaHeight / figmaBaseHeight) * height;
  }

  /// Calculate relative border radius based on Figma dimensions
  static BorderRadius getRelativeBorderRadius(
    BuildContext context,
    double figmaRadius,
  ) {
    return BorderRadius.circular(getRelativeWidth(context, figmaRadius));
  }

}
