import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_count_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_count_state.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_count_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_count_state.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_count_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_count_state.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/shared/widgets/bottom_button.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/custom_header.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:taskflow_app/shared/widgets/task/task_card_detailed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class TaskOverviewScreen extends StatefulWidget {
  const TaskOverviewScreen({super.key, required this.task});

  final TaskEntity task;

  @override
  State<TaskOverviewScreen> createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  @override
  void initState() {
    super.initState();
    // Load task details when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsTaskCountCubit>().getProductsTaskCount(
        widget.task.id,
      );
      context.read<ImageCountCubit>().getImagesCount(widget.task.id);
      context.read<CommentCountCubit>().getCommentsCount(widget.task.id);
    });
  }

  bool _isActiveTask() {
    return widget.task.status == TaskStatus.inProgress ||
        widget.task.status == TaskStatus.pending;
  }

  Future<void> _showMarkTaskAsFinishedConfirmationDialog(
    BuildContext context,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: translate('markAsFinished'),
          message: translate('areYouSureYouWantToFinishThisTask'),
          confirmText: translate('confirm'),
        );
      },
    );

    if (confirm == true) {
      context.read<TaskCubit>().editTaskStatus(
        widget.task,
        TaskStatus.finished,
        context.getUserLocationCode(),
      );
      context.go('/main');
      UIUtils.showSuccessSnackBar(
        context,
        translate('taskMarkedAsFinishedSuccessfully'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(title: translate('taskDescription')),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 30),
                ),
                TaskCardDetailed(task: widget.task),
                if (widget.task.description.isNotEmpty ||
                    widget.task.itemDescription.isNotEmpty) ...[
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                  TaskCardDescription(task: widget.task),
                ],
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 30),
                ),
                TaskCardElements(task: widget.task),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 30),
                ),
                if (_isActiveTask()) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveConstants.getRelativeHeight(
                        context,
                        40,
                      ),
                    ),
                    child: BottomButton(
                      label: translate('markAsFinished'),
                      backgroundColor: greenButtonColor,
                      onPressed: () {
                        _showMarkTaskAsFinishedConfirmationDialog(context);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskCardDescription extends StatelessWidget {
  const TaskCardDescription({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) ...[
            Text(
              translate('description'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 3)),
            Text(
              task.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
            ),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 16),
            ),
          ],
          if (task.itemDescription.isNotEmpty) ...[
            Text(
              translate('itemDescription'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 3)),
            Text(
              task.itemDescription,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
            ),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 16),
            ),
          ],
        ],
      ),
    );
  }
}

class TaskCardElements extends StatelessWidget {
  const TaskCardElements({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    // Check if user is from a collaborating workshop
    final bool isCollaborating = context.isCollaboratingWorkshop();

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('taskElements'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: foregroundColor,
            ),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<ImageCountCubit, ImageCountState>(
                  builder: (context, state) {
                    int amount = 0;
                    if (state is ImageCountLoaded) {
                      amount = state.count;
                    }
                    return AssetContainer(
                      asset: translate('photos'),
                      icon: CupertinoIcons.camera_fill,
                      amount: amount,
                      isExpanded: isCollaborating,
                    );
                  },
                ),
              ),
              // Only show products box if NOT a collaborating workshop
              if (!isCollaborating) ...[
                SizedBox(
                  width: ResponsiveConstants.getRelativeWidth(context, 8),
                ),
                Expanded(
                  child: BlocBuilder<
                    ProductsTaskCountCubit,
                    ProductsTaskCountState
                  >(
                    builder: (context, state) {
                      int amount = 0;
                      if (state is ProductsTaskCountLoaded) {
                        amount = state.count;
                      }
                      return AssetContainer(
                        asset: translate('products'),
                        icon: CupertinoIcons.archivebox_fill,
                        amount: amount,
                        isExpanded: false,
                      );
                    },
                  ),
                ),
              ],
              SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 8)),
              Expanded(
                child: BlocBuilder<CommentCountCubit, CommentCountState>(
                  builder: (context, state) {
                    int amount = 0;
                    if (state is CommentCountLoaded) {
                      amount = state.count;
                    }
                    return AssetContainer(
                      asset: translate('comments'),
                      icon: CupertinoIcons.chat_bubble_text_fill,
                      amount: amount,
                      isExpanded: isCollaborating,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          InkWell(
            onTap: () {
              context.push('/task-elements', extra: task);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveConstants.getRelativeHeight(context, 12),
              ),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius:
                    ResponsiveConstants.getRelativeBorderRadius(context, 8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility, color: foregroundColor),
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 10),
                  ),
                  Text(
                    translate('viewAllTaskElements'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetContainer extends StatelessWidget {
  const AssetContainer({
    super.key,
    required this.asset,
    required this.icon,
    required this.amount,
    this.isExpanded = false,
  });

  final String asset;
  final IconData icon;
  final int amount;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use full width when expanded (inside Expanded widget), otherwise fixed width
      width:
          isExpanded
              ? double.infinity
              : ResponsiveConstants.getRelativeWidth(context, 96),
      height: ResponsiveConstants.getRelativeHeight(context, 96),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius:
            ResponsiveConstants.getRelativeBorderRadius(context, 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: mutedForegroundColor,
            size: ResponsiveConstants.getRelativeWidth(context, 24),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 4)),
          Text(
            asset,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: mutedForegroundColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 6)),
          Text(
            '$amount',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
