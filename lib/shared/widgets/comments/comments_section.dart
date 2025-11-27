import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/card_list_header.dart';
import 'package:taskflow_app/shared/widgets/comments/comment_card.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_card_item.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_add_comment.dart';
import 'package:taskflow_app/shared/widgets/products/empty_item_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.taskId});

  final String taskId;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  void initState() {
    super.initState();
    // Load comments when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentCubit>().getComments(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardListHeader(
            title: translate('comments'),
            onAdd: () async {
              final comment = await AddCommentModal.show(context);
              if (comment != null) {
                context.read<CommentCubit>().addComment(widget.taskId, comment);
              }
            },
            icon: CupertinoIcons.chat_bubble_text_fill,
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
          BlocBuilder<CommentCubit, CommentsState>(
            builder: (context, state) {
              if (state is CommentsFailure) {
                return Center(child: Text(state.error.message));
              } else if (state is CommentsLoading) {
                return LoadingIndicatorInCardItem();
              } else if (state is CommentsLoaded) {
                if (state.comments.isEmpty) {
                  return EmptyItemPlaceholder(
                    iconItem: CupertinoIcons.doc_text_fill,
                    noItemsAdded: translate('noCommentsAddedYet'),
                    addItem: translate('addComment'),
                    onAdd: () async {
                      final comment = await AddCommentModal.show(context);
                      if (comment != null) {
                        context.read<CommentCubit>().addComment(
                          widget.taskId,
                          comment,
                        );
                      }
                    },
                  );
                } else {
                  return Column(
                    children:
                        state.comments.asMap().entries.map((entry) {
                          final index = entry.key;
                          final comment = entry.value;

                          return Column(
                            children: [
                              CommentCard(
                                comment: comment,
                                onDelete:
                                    () => _showDeleteConfirmationDialog(
                                      context,
                                      comment.systemId!,
                                    ),
                              ),
                              if (index != state.comments.length - 1)
                                SizedBox(
                                  height: ResponsiveConstants.getRelativeHeight(
                                    context,
                                    20,
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                  );
                }
              } else {
                return LoadingIndicatorInCardItem();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String commentSystemId,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: translate('deleteComment'),
          message: translate('areYouSureYouWantToDeleteThisComment'),
          confirmText: translate('delete'),
        );
      },
    );

    if (confirm == true) {
      context.read<CommentCubit>().deleteComment(
        widget.taskId,
        commentSystemId,
      );
    }
  }
}
