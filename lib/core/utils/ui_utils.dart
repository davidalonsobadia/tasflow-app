import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:flutter/material.dart';

class UIUtils {
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    double? bottomMargin,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          right: ResponsiveConstants.getRelativeWidth(context, 16),
          left: ResponsiveConstants.getRelativeWidth(context, 16),
          bottom:
              bottomMargin ??
              ResponsiveConstants.getRelativeHeight(context, 24),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
