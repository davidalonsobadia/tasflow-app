import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskStatus.finished:
        backgroundColor = Colors.lightBlue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case TaskStatus.pending:
        backgroundColor = pendingColor;
        textColor = onPendingColor;
        break;
      case TaskStatus.inProgress:
      case TaskStatus.validated:
        backgroundColor = inProgressColor;
        textColor = onInProgressColor;
        break;
      case TaskStatus.onHold:
        backgroundColor = onHoldColor;
        textColor = onOnHoldColor;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 8),
        vertical: ResponsiveConstants.getRelativeHeight(context, 4),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 20),
      ),
      child: Text(
        translate(status.translationKey),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}
