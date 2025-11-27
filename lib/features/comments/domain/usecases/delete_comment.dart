import 'package:taskflow_app/features/comments/domain/repositories/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> deleteComment(String systemId, String taskId) {
    return repository.deleteComment(systemId, taskId);
  }
}
