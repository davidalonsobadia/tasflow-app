import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';
import 'package:taskflow_app/features/comments/domain/repositories/comment_repository.dart';
import 'package:intl/intl.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  // Constants for comment processing
  final int maxChunkSize;
  final int lineNumberIncrement;
  final int initialLineNumber;

  AddCommentUseCase(
    this.repository, {
    this.maxChunkSize = 250,
    this.lineNumberIncrement = 10000,
    this.initialLineNumber = 10000,
  });

  Future<List<CommentEntity>> addComment(String taskId, String message) async {
    // Get existing comments to determine line numbers
    final existingComments = await repository.getComments(taskId);

    // Split message into chunks
    final List<String> commentChunks = _splitCommentIntoChunks(message);

    // Calculate base line number
    int baseLineNumber = _getNextLineNumber(existingComments);

    // Add each chunk as a separate comment
    List<CommentEntity> addedComments = [];
    for (int i = 0; i < commentChunks.length; i++) {
      final newComment = CommentEntity(
        taskId: taskId,
        date: _getCurrentDate(),
        lineNumber: baseLineNumber + (i * lineNumberIncrement),
        message: commentChunks[i],
      );

      final addedComment = await repository.addComment(newComment);
      addedComments.add(addedComment);
    }

    return addedComments;
  }

  /// Splits a comment into chunks of specified size
  List<String> _splitCommentIntoChunks(String comment) {
    final chunks = <String>[];
    for (var i = 0; i < comment.length; i += maxChunkSize) {
      final end = i + maxChunkSize;
      chunks.add(comment.substring(i, end.clamp(0, comment.length)));
    }
    return chunks;
  }

  /// Gets the next line number based on existing comments
  int _getNextLineNumber(List<CommentEntity> comments) {
    if (comments.isEmpty) {
      return initialLineNumber;
    }

    int highestLineNumber = initialLineNumber;
    for (var comment in comments) {
      if (comment.lineNumber > highestLineNumber) {
        highestLineNumber = comment.lineNumber;
      }
    }

    return highestLineNumber + lineNumberIncrement;
  }

  /// Gets the current date formatted as yyyy-MM-dd
  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
