import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:taskflow_app/features/collaborations/presentation/cubit/collaboration_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_cubit.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/comments/comments_section.dart';
import 'package:taskflow_app/shared/widgets/custom_header.dart';
import 'package:taskflow_app/shared/widgets/dialogs/complete_collaboration_dialog.dart';
import 'package:taskflow_app/shared/widgets/dialogs/complete_collaboration_result.dart';
import 'package:taskflow_app/shared/widgets/images/attachments_section.dart';
import 'package:taskflow_app/shared/widgets/loading_overlay.dart';
import 'package:taskflow_app/shared/widgets/products/products_section.dart';
import 'package:taskflow_app/shared/widgets/task/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class TaskTrackingScreen extends StatefulWidget {
  final TaskEntity taskEntity;

  const TaskTrackingScreen({super.key, required this.taskEntity});

  @override
  State<TaskTrackingScreen> createState() => _TaskTrackingScreenState();
}

class _TaskTrackingScreenState extends State<TaskTrackingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    // Start timer after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the top when the widget is rebuilt
      _scrollToTop();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDeleteProductTask() {
    _scrollToTop();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showCollaborationDialog() async {
    final result = await showDialog<CompleteCollaborationResult>(
      context: context,
      builder: (BuildContext context) {
        return CompleteCollaborationDialog(
          title: translate('completeTask'),
          message: translate('addCommentAboutTheWorkCompleted'),
          confirmText: translate('finish'),
          hintText: translate('typeYourCommentHere'),
        );
      },
    );

    if (result != null) {
      // Show loading overlay while processing
      await LoadingOverlay().during(
        context,
        _processCollaborationResult(result),
        message: translate('savingYourWork'),
      );
    }
  }

  // Extract the processing logic to a separate method
  Future<void> _processCollaborationResult(
    CompleteCollaborationResult result,
  ) async {
    // User confirmed, upload collaboration
    final endTime = DateTime.now().toUtc();

    // Get user ID from AuthCubit
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    // Edit task status to completed
    if (result.isTaskFinished) {
      final taskCubit = context.read<TaskCubit>();
      await taskCubit.editTaskStatus(
        widget.taskEntity,
        TaskStatus.finished,
        context.getUserLocationCode(),
      );
    }

    final startingDateTime = widget.taskEntity.orderDate;
    final endingDateTime = endTime.toIso8601String();

    // Upload collaboration
    final collaborationCubit = context.read<CollaborationCubit>();
    await collaborationCubit.uploadCollaborations(
      widget.taskEntity.id,
      userId,
      startingDateTime,
      endingDateTime,
      result.comment,
    );

    //Add message to the list of comments
    final commentCubit = context.read<CommentCubit>();
    await commentCubit.addComment(widget.taskEntity.id, result.comment);

    // Stop timer and navigate back to home
    if (mounted) context.go('/main');
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    context.read<ProductTaskCubit>().getProductTasksByTaskId(
      widget.taskEntity.id,
      widget.taskEntity.locationCode,
    );
    context.read<CommentCubit>().refreshComments(widget.taskEntity.id);
    context.read<ImageCubit>().refreshImages(widget.taskEntity.id);

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: translate('taskDetails')),
            Expanded(
              child: RefreshIndicator(
                displacement: ResponsiveConstants.getRelativeHeight(
                  context,
                  20,
                ),
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveConstants.getRelativeWidth(
                      context,
                      24,
                    ),
                  ),
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration:
                            _isRefreshing
                                ? Duration(milliseconds: 100)
                                : Duration(milliseconds: 200),
                        child: SizedBox(
                          height:
                              _isRefreshing
                                  ? ResponsiveConstants.getRelativeHeight(
                                    context,
                                    60,
                                  )
                                  : 0,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                      TaskCard(task: widget.taskEntity),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                      _buildTimerSection(context),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                      _buildProductsSection(context),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                      _buildAttachmentsSection(context, widget.taskEntity.id),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                      _buildCommentsSection(context, widget.taskEntity.id),
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context, String taskId) {
    return CommentsSection(taskId: taskId);
  }

  Widget _buildAttachmentsSection(BuildContext context, String taskId) {
    return AttachmentsSection(taskId: taskId);
  }

  Widget _buildProductsSection(BuildContext context) {
    return ProductsSection(
      taskId: widget.taskEntity.id,
      locationCode: widget.taskEntity.locationCode,
      onDelete: (systemId) {
        context.read<ProductTaskCubit>().deleteProductTask(
          widget.taskEntity.id,
          widget.taskEntity.locationCode,
          systemId,
        );
        _onDeleteProductTask();
      },
    );
  }

  Widget _buildTrackingAs(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) return SizedBox.shrink();
        // Format as "First L."
        final parts =
            state.user.name
                .trim()
                .split(' ')
                .where((p) => p.isNotEmpty)
                .toList();
        String display =
            parts.isEmpty
                ? ''
                : (parts.length == 1
                    ? parts.first
                    : '${parts.first} ${parts.last[0].toUpperCase()}.');
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            display,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
          ),
        );
      },
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 24),
        horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTrackingAs(context),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 10)),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 6)),
          Text(
            translate('timeElapsed'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: ResponsiveConstants.getRelativeWidth(context, 64),
                  height: ResponsiveConstants.getRelativeHeight(context, 64),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: mutedForegroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 30),
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveConstants.getRelativeWidth(context, 18),
              ),
              GestureDetector(
                onTap: () {
                  _showCollaborationDialog();
                },
                child: Container(
                  width: ResponsiveConstants.getRelativeWidth(context, 64),
                  height: ResponsiveConstants.getRelativeHeight(context, 64),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.stop,
                    color: primaryForegroundColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// New dialog for collaboration completion
class _CollaborationCompletionDialog extends StatefulWidget {
  @override
  _CollaborationCompletionDialogState createState() =>
      _CollaborationCompletionDialogState();
}

class _CollaborationCompletionDialogState
    extends State<_CollaborationCompletionDialog> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: ResponsiveConstants.getRelativeHeight(context, 20),
        left: ResponsiveConstants.getRelativeWidth(context, 20),
        right: ResponsiveConstants.getRelativeWidth(context, 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('completeTask'),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Text(
            translate('addCommentAboutTheWorkCompleted'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 8),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: translate('typeYourCommentHere'),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  translate('cancel'),
                  style: TextStyle(color: mutedForegroundColor),
                ),
              ),
              SizedBox(
                width: ResponsiveConstants.getRelativeWidth(context, 16),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _commentController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: primaryForegroundColor,
                ),
                child: Text(translate('finish')),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
        ],
      ),
    );
  }
}
