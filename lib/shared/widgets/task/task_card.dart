import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/status_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        TaskEntity displayedTask = task;
        if (state is TaskLoaded) {
          displayedTask = state.tasks.firstWhere(
            (t) => t.id == task.id,
            orElse: () => task,
          );
        }

        return GestureDetector(
          onTap: onTap ?? () {},
          child: CardContainer(
            margin: EdgeInsets.only(
              bottom: ResponsiveConstants.getRelativeHeight(context, 20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        displayedTask.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveConstants.getRelativeWidth(context, 8),
                    ),
                    _buildStatusBadge(context, displayedTask.status),
                  ],
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 10),
                ),
                _buildTaskMetadata(
                  context,
                  displayedTask,
                  Icons.perm_identity,
                  displayedTask.id,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 6),
                ),
                _buildTaskMetadata(
                  context,
                  displayedTask,
                  CupertinoIcons.car,
                  displayedTask.licensePlate,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 6),
                ),
                if (displayedTask.status == TaskStatus.pending ||
                    displayedTask.status == TaskStatus.inProgress) ...[
                  _buildTaskMetadata(
                    context,
                    displayedTask,
                    CupertinoIcons.time,
                    displayedTask.orderDate,
                  ),
                ] else ...[
                  _buildTaskMetadata(
                    context,
                    displayedTask,
                    CupertinoIcons.time,
                    displayedTask.finishingDate,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, TaskStatus status) {
    return StatusBadge(status: status);
  }

  Widget _buildTaskMetadata(
    BuildContext context,
    TaskEntity task,
    IconData iconData,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          iconData,
          color: textColor,
          size: ResponsiveConstants.getRelativeWidth(context, 16),
        ),
        SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 4)),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
