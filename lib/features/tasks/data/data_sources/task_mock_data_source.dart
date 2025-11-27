import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:taskflow_app/features/tasks/data/models/task_line_model.dart';
import 'package:taskflow_app/features/tasks/data/models/task_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of TaskRemoteDataSource for testing without real API
class TaskMockDataSource implements TaskRemoteDataSource {
  final List<Map<String, dynamic>> _mockTasks = [
    {
      'no': 'TASK001',
      'name': 'Install Equipment',
      'systemId': 'sys-task-001',
      'aitLicensePlate': 'ABC123',
      'status': 'In Progress',
      'orderDate': '2024-01-15T10:00:00Z',
      'finishingDate': '2024-01-20T18:00:00Z',
      'description': 'Install new equipment at customer site',
      'itemDescription': 'Equipment Installation',
      'locationCode': 'LOC001',
      'shortcutDimension1Code': 'DEPT01',
      'shortcutDimension2Code': 'PROJ01',
    },
    {
      'no': 'TASK002',
      'name': 'Maintenance Service',
      'systemId': 'sys-task-002',
      'aitLicensePlate': 'XYZ789',
      'status': 'Pending',
      'orderDate': '2024-01-16T09:00:00Z',
      'finishingDate': '2024-01-22T17:00:00Z',
      'description': 'Regular maintenance check',
      'itemDescription': 'Maintenance',
      'locationCode': 'LOC002',
      'shortcutDimension1Code': 'DEPT02',
      'shortcutDimension2Code': 'PROJ02',
    },
    {
      'no': 'TASK003',
      'name': 'Repair Work',
      'systemId': 'sys-task-003',
      'aitLicensePlate': 'DEF456',
      'status': 'Completed',
      'orderDate': '2024-01-10T08:00:00Z',
      'finishingDate': '2024-01-14T16:00:00Z',
      'description': 'Emergency repair',
      'itemDescription': 'Repair',
      'locationCode': 'LOC001',
      'shortcutDimension1Code': 'DEPT01',
      'shortcutDimension2Code': 'PROJ03',
    },
  ];

  final List<Map<String, dynamic>> _mockTaskLines = [
    {
      'systemId': 'line-001',
      'documentNo': 'TASK001',
      'lineNo': 10000,
      'type': 'Item',
      'no': 'ITEM001',
      'description': 'Main component',
      'quantity': 2.0,
      'unitOfMeasure': 'PCS',
    },
    {
      'systemId': 'line-002',
      'documentNo': 'TASK001',
      'lineNo': 20000,
      'type': 'Item',
      'no': 'ITEM002',
      'description': 'Secondary component',
      'quantity': 5.0,
      'unitOfMeasure': 'PCS',
    },
  ];

  @override
  Future<List<TaskModel>> getAllTasks(String locationCode) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    var tasks = _mockTasks;
    
    // Filter by location if provided
    if (locationCode.isNotEmpty) {
      tasks = tasks.where((t) => t['locationCode'] == locationCode).toList();
    }

    return tasks.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<List<TaskLineModel>> getTaskLines(String taskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final lines = _mockTaskLines
        .where((line) => line['documentNo'] == taskId)
        .toList();

    return lines.map((json) => TaskLineModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> editTaskStatus(String taskId, String status) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final taskIndex = _mockTasks.indexWhere((t) => t['systemId'] == taskId);
    
    if (taskIndex == -1) {
      throw ServerException(
        translate('failedToUpdateTaskStatus'),
        null,
      );
    }

    // Update the status
    _mockTasks[taskIndex]['status'] = status;

    return TaskModel.fromJson(_mockTasks[taskIndex]);
  }
}

