import 'package:taskflow_app/features/comments/data/data_sources/comment_remote_data_source.dart';
import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';
import 'package:taskflow_app/features/comments/domain/repositories/comment_repository.dart';
import 'package:taskflow_app/features/comments/data/models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  // Add cache map
  final Map<String, List<CommentEntity>> _cachedComments = {};

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CommentEntity>> getComments(String taskId) async {
    // Return cached comments if available
    if (_cachedComments.containsKey(taskId) &&
        _cachedComments[taskId]!.isNotEmpty) {
      return _cachedComments[taskId]!;
    }

    // Otherwise fetch from remote
    final comments = await remoteDataSource
        .getComments(taskId)
        .then(
          (comments) =>
              comments
                  .map(
                    (comment) => CommentEntity(
                      taskId: comment.taskId,
                      date: comment.date,
                      lineNumber: comment.lineNumber,
                      message: comment.message,
                      systemId: comment.systemId,
                    ),
                  )
                  .toList(),
        );

    // Update cache
    _cachedComments[taskId] = comments;
    return comments;
  }

  @override
  Future<CommentEntity> addComment(CommentEntity comment) async {
    final response = await remoteDataSource.addComment(
      CommentModel(
        taskId: comment.taskId,
        date: comment.date,
        lineNumber: comment.lineNumber,
        message: comment.message,
      ),
    );

    final newComment = CommentEntity(
      taskId: response.taskId,
      date: response.date,
      lineNumber: response.lineNumber,
      message: response.message,
      systemId: response.systemId,
    );

    // Update cache
    if (_cachedComments[comment.taskId] == null) {
      _cachedComments[comment.taskId] = [newComment];
    } else {
      _cachedComments[comment.taskId]!.add(newComment);
    }

    return newComment;
  }

  @override
  Future<void> deleteComment(String systemId, String taskId) async {
    await remoteDataSource.deleteComment(systemId);

    // Update cache if it exists
    if (_cachedComments.containsKey(taskId)) {
      _cachedComments[taskId]!.removeWhere(
        (comment) => comment.systemId == systemId,
      );
    }
  }

  // Add method to refresh cache
  @override
  Future<List<CommentEntity>> refreshComments(String taskId) async {
    final comments = await remoteDataSource
        .getComments(taskId)
        .then(
          (comments) =>
              comments
                  .map(
                    (comment) => CommentEntity(
                      taskId: comment.taskId,
                      date: comment.date,
                      lineNumber: comment.lineNumber,
                      message: comment.message,
                      systemId: comment.systemId,
                    ),
                  )
                  .toList(),
        );

    _cachedComments[taskId] = comments;
    return comments;
  }

  @override
  Future<int> getCommentsCount(String taskId) async {
    return remoteDataSource.getCommentsCount(taskId);
  }
}
