import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getComments(String taskId);
  Future<CommentEntity> addComment(CommentEntity comment);
  Future<void> deleteComment(String systemId, String taskId);
  Future<List<CommentEntity>> refreshComments(String taskId);
  Future<int> getCommentsCount(String taskId);
}
