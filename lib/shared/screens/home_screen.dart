import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_screen.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_vehicle_info.dart';
import 'package:taskflow_app/shared/widgets/task/task_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskEntity> _activeTasks = [];
  // Add filter type enum or string
  String _currentFilter = 'all_active'; // 'all_active' or 'in_progress'

  List<TaskEntity> _getActiveTasks(List<TaskEntity> tasks) {
    if (_currentFilter == 'in_progress') {
      return tasks
          .where((task) => task.status == TaskStatus.inProgress)
          .toList();
    }
    // Default filter (all active)
    return tasks
        .where(
          (task) =>
              task.status == TaskStatus.inProgress ||
              task.status == TaskStatus.pending,
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    if (context.read<TaskCubit>().state is TaskLoaded) {
      final state = context.read<TaskCubit>().state as TaskLoaded;
      _activeTasks = _getActiveTasks(state.tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
        vertical: ResponsiveConstants.getRelativeHeight(context, 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(context),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 31)),
          _buildQuickActionsCard(context),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 31)),
          _buildTasksHeader(context),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskLoaded) {
                setState(() {
                  _activeTasks = _getActiveTasks(state.tasks);
                });
              }
            },
            builder: (context, state) {
              if (state is TaskLoaded) {
                return _buildTasksList(context, _activeTasks);
              } else if (state is TaskFailure) {
                return Center(child: Text(state.error.message));
              }
              return Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveConstants.getRelativeHeight(context, 36),
                ),
                child: LoadingIndicatorInScreen(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        int activeTasksCount = 0;
        int inProgressCount = 0;

        if (state is TaskLoaded) {
          activeTasksCount =
              state.tasks
                  .where(
                    (task) =>
                        task.status == TaskStatus.inProgress ||
                        task.status == TaskStatus.pending,
                  )
                  .length;
          inProgressCount =
              state.tasks
                  .where((task) => task.status == TaskStatus.inProgress)
                  .length;
        }

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentFilter = 'all_active';
                  if (state is TaskLoaded) {
                    _activeTasks = _getActiveTasks(state.tasks);
                  }
                });
              },
              child: _buildStatCard(
                context,
                translate('activeTasks'),
                activeTasksCount.toString(),
                Icons.adjust,
                _currentFilter == 'all_active' ? primaryColor : secondaryColor,
                _currentFilter == 'all_active'
                    ? primaryForegroundColor
                    : primaryColor,
              ),
            ),
            SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 16)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentFilter = 'in_progress';
                  if (state is TaskLoaded) {
                    _activeTasks = _getActiveTasks(state.tasks);
                  }
                });
              },
              child: _buildStatCard(
                context,
                translate('inProgress'),
                inProgressCount.toString(),
                Icons.sync,
                _currentFilter == 'in_progress'
                    ? priorityMediumColor
                    : secondaryColor,
                _currentFilter == 'in_progress'
                    ? backgroundColor
                    : priorityMediumColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
  ) {
    return CardContainer(
      width: ResponsiveConstants.getRelativeWidth(context, 163),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveConstants.getRelativeWidth(context, 37),
                height: ResponsiveConstants.getRelativeHeight(context, 40),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: ResponsiveConstants.getRelativeBorderRadius(
                    context,
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: ResponsiveConstants.getRelativeWidth(context, 16),
                ),
              ),
              SizedBox(
                width: ResponsiveConstants.getRelativeWidth(context, 12),
              ),
              SizedBox(
                width: ResponsiveConstants.getRelativeWidth(context, 82),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mutedForegroundColor,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 10)),
          Padding(
            padding: EdgeInsets.only(
              left: ResponsiveConstants.getRelativeWidth(context, 3),
            ),
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return CardContainer(
      width: ResponsiveConstants.getRelativeWidth(context, 343),
      padding: EdgeInsets.all(
        ResponsiveConstants.getRelativeWidth(context, 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('quickActions'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 10)),
          Row(
            children: [
              _buildActionButton(
                context,
                translate('newTask'),
                Icons.add,
                primaryColor,
                primaryForegroundColor,
                onTap: () {
                  final modalBottomSheet = ModalBottomVehicleInfo(
                    onTaskSelected: (task) {
                      // Handle vehicle selection
                      context.push('/task-overview', extra: task);
                    },
                  );
                  modalBottomSheet.show(context);
                },
              ),
              SizedBox(
                width: ResponsiveConstants.getRelativeWidth(context, 16),
              ),
              _buildActionButton(
                context,
                translate('history'),
                Icons.history,
                secondaryColor,
                secondaryForegroundColor,
                onTap: () => context.go('/task-history'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveConstants.getRelativeWidth(context, 139),
        height: ResponsiveConstants.getRelativeHeight(context, 104),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(
            context,
            12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    bgColor == primaryColor
                        ? primaryForegroundColor
                        : foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _currentFilter == 'in_progress'
                ? translate('inProgressTasks')
                : translate('activeTasks'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              // Reset filter to default 'all_active' and refresh tasks
              setState(() {
                _currentFilter = 'all_active';
              });
              context.read<TaskCubit>().refreshTasks(
                context.getUserLocationCode(),
              );
            },
            child: Icon(
              CupertinoIcons.refresh,
              color: primaryColor,
              size: ResponsiveConstants.getRelativeWidth(context, 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<TaskEntity> tasks) {
    return tasks.isEmpty
        ? _buildEmptyTasksView(context)
        : Column(
          children:
              tasks
                  .map(
                    (task) => TaskCard(
                      task: task,
                      onTap: () {
                        context.push('/task-overview', extra: task);
                      },
                    ),
                  )
                  .toList(),
        );
  }

  Widget _buildEmptyTasksView(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 30),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/assignment.png'),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 14)),
          Text(
            translate('noActiveTasks'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 10)),
          Text(
            translate('tapNewTaskToGetStarted'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
