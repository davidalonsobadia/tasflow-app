import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorInScreen extends StatelessWidget {
  const LoadingIndicatorInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 24),
      ),
      child: Center(child: CircularProgressIndicator(strokeWidth: 3.5)),
    );
  }
}
