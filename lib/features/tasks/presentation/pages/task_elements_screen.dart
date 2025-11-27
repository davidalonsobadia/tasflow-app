import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_cubit.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/shared/widgets/comments/comments_section.dart';
import 'package:taskflow_app/shared/widgets/custom_header.dart';
import 'package:taskflow_app/shared/widgets/images/attachments_section.dart';
import 'package:taskflow_app/shared/widgets/products/products_section.dart';
import 'package:taskflow_app/shared/widgets/task/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TaskElementsScreen extends StatefulWidget {
  final TaskEntity taskEntity;

  const TaskElementsScreen({super.key, required this.taskEntity});

  @override
  State<TaskElementsScreen> createState() => _TaskElementsScreenState();
}

class _TaskElementsScreenState extends State<TaskElementsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        CustomHeader(title: translate('taskElements')),
        Expanded(
          child: RefreshIndicator(
            displacement: ResponsiveConstants.getRelativeHeight(context, 20),
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
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
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                  TaskCard(task: widget.taskEntity),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                  _buildProductsSection(context),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                  _buildAttachmentsSection(context, widget.taskEntity.id),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                  _buildCommentsSection(context, widget.taskEntity.id),
                  SizedBox(
                    height: ResponsiveConstants.getRelativeHeight(context, 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
      modalBottomHeightPercentage: 0.75,
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
                child: Text(translate('cancel')),
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
                  foregroundColor: whiteColor,
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
