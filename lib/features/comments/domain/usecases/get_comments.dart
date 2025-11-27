import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';
import 'package:taskflow_app/features/comments/domain/repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<CommentEntity>> getComments(String taskId) async {
    final comments = await repository.getComments(taskId);
    return comments.reversed.toList();
  }

  Future<List<CommentEntity>> refreshComments(String taskId) async {
    final comments = await repository.refreshComments(taskId);
    return comments.reversed.toList();
  }

  Future<int> getCommentsCount(String taskId) async {
    final count = await repository.getCommentsCount(taskId);
    return count;
  }
}
