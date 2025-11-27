import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/network/endpoints.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/collaborations/data/models/collaboration_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class CollaborationRemoteDataSource {
  Future<void> uploadCollaboration(CollaborationModel collaboration);
}

class CollaborationRemoteDataSourceImpl
    implements CollaborationRemoteDataSource {
  final DioApiClient apiClient;

  CollaborationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> uploadCollaboration(CollaborationModel collaboration) async {
    final response = await apiClient.post(
      Endpoints.collaborationsEndpoint,
      data: collaboration.toJson(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(translate('failedToUploadCollaboration'), response);
    }
  }
}
