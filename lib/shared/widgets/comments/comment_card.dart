import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';
import 'package:taskflow_app/shared/widgets/products/trash_icon.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment, required this.onDelete});

  final CommentEntity comment;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 10),
        horizontal: ResponsiveConstants.getRelativeWidth(context, 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.date,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
              ),
              TrashIcon(onDelete: onDelete),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 7)),
          Text(
            comment.message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
