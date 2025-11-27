import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentEntity> comments;
  CommentsLoaded(this.comments);
}

class CommentsFailure extends CommentsState {
  final AppError error;
  CommentsFailure(this.error);
}
