import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space2,
        vertical: AppSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border.all(color: colors.foreground.withOpacity(0.3), width: 1),
      ),
      child: Text(
        translate(status.translationKey),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w500,
          fontSize: AppTypography.fontSizeXs,
        ),
      ),
    );
  }

  _StatusColors _getStatusColors() {
    switch (status) {
      case TaskStatus.finished:
        return _StatusColors(
          background: finishedBgColor,
          foreground: onFinishedColor,
        );
      case TaskStatus.pending:
        return _StatusColors(
          background: pendingBgColor,
          foreground: onPendingColor,
        );
      case TaskStatus.inProgress:
        return _StatusColors(
          background: inProgressBgColor,
          foreground: onInProgressColor,
        );
      case TaskStatus.validated:
        return _StatusColors(
          background: validatedBgColor,
          foreground: onValidatedColor,
        );
      case TaskStatus.onHold:
        return _StatusColors(
          background: onHoldBgColor,
          foreground: onOnHoldColor,
        );
    }
  }
}

class _StatusColors {
  final Color background;
  final Color foreground;

  _StatusColors({required this.background, required this.foreground});
}
