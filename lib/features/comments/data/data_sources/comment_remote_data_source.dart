import 'package:dio/dio.dart';
import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/network/endpoints.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/comments/data/models/comment_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments(String taskId);
  Future<CommentModel> addComment(CommentModel comment);
  Future<void> deleteComment(String systemId);
  Future<int> getCommentsCount(String taskId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final DioApiClient apiClient;

  CommentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CommentModel>> getComments(String taskId) async {
    final queryParams = {
      "\$top": 10,
      "\$skip": 0,
      "\$select": "no,lineNo,date,comment,SystemId",
      "\$filter": "no eq '$taskId'",
    };

    final response = await apiClient.get(
      Endpoints.commentsEndpoint,
      params: queryParams,
    );
    if (response.statusCode != 200) {
      throw ServerException(translate('failedToLoadComments'), response);
    }

    if (response.data['value'] == null) {
      throw ValidationException(
        translate('invalidCommentDataFormat'),
        response,
      );
    }

    List<dynamic> commentsData = response.data['value'];
    return commentsData
        .map((commentData) => CommentModel.fromJson(commentData))
        .toList();
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    final response = await apiClient.post(
      Endpoints.commentsEndpoint,
      data: comment.toJson(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(translate('failedToAddComment'), response);
    }
    return CommentModel.fromJson(response.data);
  }

  @override
  Future<void> deleteComment(String systemId) async {
    String deleteParam = '($systemId)';
    final response = await apiClient.delete(
      Endpoints.commentsEndpoint + deleteParam,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(translate('failedToDeleteComment'), response);
    }
  }

  @override
  Future<int> getCommentsCount(String taskId) async {
    final queryParams = Map<String, dynamic>.from({
      "\$count": "true",
      "\$top": 0,
      "\$filter": "no eq '$taskId'",
    });
    try {
      final response = await apiClient.get(
        Endpoints.commentsEndpoint,
        params: queryParams,
      );
      if (response.statusCode != 200) {
        throw ServerException("Failed to get comments count", response);
      }
      return response.data['@odata.count'];
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadComments'), e.response);
      }
      throw ValidationException(translate('invalidCommentDataFormat'), e);
    }
  }
}
