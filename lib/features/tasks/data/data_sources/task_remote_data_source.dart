import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/network/endpoints.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/tasks/data/models/task_line_model.dart';
import 'package:taskflow_app/features/tasks/data/models/task_model.dart';
import 'package:taskflow_app/core/utils/pagination_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getAllTasks(String locationCode);
  Future<List<TaskLineModel>> getTaskLines(String taskId);
  Future<TaskModel> editTaskStatus(String taskId, String status);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final DioApiClient apiClient;

  TaskRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TaskModel>> getAllTasks(String locationCode) async {
    String? locationFilter;
    if (locationCode.isNotEmpty) {
      locationFilter = "locationCode eq '$locationCode'";
    }

    final paginationHelper = PaginationHelper<TaskModel>(
      apiCall:
          (params) => apiClient.get(Endpoints.tasksEndpoint, params: params),
      fromJson: (json) => TaskModel.fromJson(json),
    );

    final baseParams = {
      "\$select":
          "no,name,systemId,aitLicensePlate,status,orderDate,finishingDate,description,itemDescription,locationCode,shortcutDimension1Code,shortcutDimension2Code",
      "\$orderby": "finishingDate desc",
    };

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        filterQuery: locationFilter,
      );
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadTasks'), e.response);
      }
      throw ValidationException(translate('invalidTaskDataFormat'), e);
    }
  }

  @override
  Future<List<TaskLineModel>> getTaskLines(String taskId) async {
    final paginationHelper = PaginationHelper<TaskLineModel>(
      apiCall:
          (params) =>
              apiClient.get(Endpoints.taskLinesEndpoint, params: params),
      fromJson: (json) => TaskLineModel.fromJson(json),
    );

    final baseParams = {"\$select": "documentNo,serviceItemNo,lineNo"};

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        filterQuery: "documentNo eq '$taskId'",
      );
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadTaskLines'), e.response);
      }
      throw ValidationException(translate('invalidTaskLineDataFormat'), e);
    }
  }

  @override
  Future<TaskModel> editTaskStatus(String systemId, String status) {
    final result = apiClient.patch(
      "${Endpoints.tasksEndpoint}($systemId)",
      data: {"status": status},
    );
    return result.then((response) => TaskModel.fromJson(response.data));
  }
}
