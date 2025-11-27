import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorWithProgressInScreen extends StatelessWidget {
  final double progress;
  final String message;

  const LoadingIndicatorWithProgressInScreen({
    super.key,
    required this.progress,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: progress, strokeWidth: 3.5),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 16),
            ),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
