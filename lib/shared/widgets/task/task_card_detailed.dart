import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TaskCardDetailed extends StatelessWidget {
  final TaskEntity task;

  const TaskCardDetailed({super.key, required this.task});

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
        return CardContainer(
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
                Icons.assignment,
                translate('taskId'),
                displayedTask.id,
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 10),
              ),
              if (displayedTask.equipmentCode != '') ...[
                _buildTaskMetadata(
                  context,
                  Icons.devices,
                  translate('codeEquipment'),
                  displayedTask.equipmentCode,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 10),
                ),
              ],
              if (displayedTask.projectCode != '') ...[
                _buildTaskMetadata(
                  context,
                  Icons.code,
                  translate('codeProject'),
                  displayedTask.projectCode,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 10),
                ),
              ],
              _buildTaskMetadata(
                context,
                Icons.directions_car,
                translate('licensePlate'),
                displayedTask.licensePlate,
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 10),
              ),
              _buildTaskMetadata(
                context,
                Icons.timer,
                translate('orderDate'),
                displayedTask.orderDate,
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 10),
              ),
              if (displayedTask.status == TaskStatus.finished ||
                  displayedTask.status == TaskStatus.validated) ...[
                _buildTaskMetadata(
                  context,
                  Icons.flag,
                  translate('finishingDate'),
                  displayedTask.finishingDate,
                ),
              ],
            ],
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
    IconData icon,
    String taskLabel,
    String taskValue,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: greyTextColor,
          size: ResponsiveConstants.getRelativeWidth(context, 16),
        ),
        SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 4)),
        Flexible(
          child: Text(
            maxLines: 2,
            "$taskLabel: $taskValue",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: greyTextColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 35)),
      ],
    );
  }
}
