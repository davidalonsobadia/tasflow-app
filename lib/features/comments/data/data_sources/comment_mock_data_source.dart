import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/comments/data/data_sources/comment_remote_data_source.dart';
import 'package:taskflow_app/features/comments/data/models/comment_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of CommentRemoteDataSource for testing without real API
class CommentMockDataSource implements CommentRemoteDataSource {
  final List<Map<String, dynamic>> _mockComments = [
    {
      'no': 'TASK001',
      'lineNo': 10000,
      'date': '2024-01-15T14:30:00Z',
      'comment': 'Started installation process',
      'SystemId': 'comment-001',
    },
    {
      'no': 'TASK001',
      'lineNo': 20000,
      'date': '2024-01-16T10:15:00Z',
      'comment': 'Equipment delivered on site',
      'SystemId': 'comment-002',
    },
    {
      'no': 'TASK002',
      'lineNo': 10000,
      'date': '2024-01-16T11:00:00Z',
      'comment': 'Scheduled for next week',
      'SystemId': 'comment-003',
    },
  ];

  int _nextLineNo = 30000;
  int _nextCommentId = 4;

  @override
  Future<List<CommentModel>> getComments(String taskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final comments = _mockComments.where((c) => c['no'] == taskId).toList();

    return comments.map((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final newComment = {
      'no': comment.taskId,
      'lineNo': _nextLineNo,
      'date': DateTime.now().toIso8601String(),
      'comment': comment.message,
      'SystemId': 'comment-${_nextCommentId.toString().padLeft(3, '0')}',
    };

    _mockComments.add(newComment);
    _nextLineNo += 10000;
    _nextCommentId++;

    return CommentModel.fromJson(newComment);
  }

  @override
  Future<void> deleteComment(String systemId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockComments.indexWhere((c) => c['SystemId'] == systemId);

    if (index == -1) {
      throw ServerException(translate('failedToDeleteComment'), null);
    }

    _mockComments.removeAt(index);
  }

  @override
  Future<int> getCommentsCount(String taskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockComments.where((c) => c['no'] == taskId).length;
  }
}
