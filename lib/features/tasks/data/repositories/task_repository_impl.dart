import 'package:taskflow_app/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:taskflow_app/features/tasks/data/models/mappers/task_status_mapper.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_line_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});
  // Cache for tasks
  final List<TaskEntity> _cachedTasks = [];

  @override
  Future<List<TaskEntity>> getAllTasks(String locationCode) async {
    if (_cachedTasks.isNotEmpty) {
      return _cachedTasks;
    }
    final taskModels = await remoteDataSource.getAllTasks(locationCode);
    final taskEntities =
        taskModels
            .map(
              (task) => TaskEntity(
                id: task.id,
                systemId: task.systemId,
                name: task.name,
                description: task.description,
                itemDescription: task.itemDescription,
                status: task.status,
                licensePlate: task.licensePlate,
                orderDate: task.orderDate,
                finishingDate: task.finishingDate,
                locationCode: task.locationCode,
                equipmentCode: task.equipmentCode,
                projectCode: task.projectCode,
              ),
            )
            .toList();

    _cachedTasks.clear();
    _cachedTasks.addAll(taskEntities);
    return taskEntities;
  }

  @override
  Future<List<TaskEntity>> refreshTasks(String locationCode) async {
    final taskModels = await remoteDataSource.getAllTasks(locationCode);
    final taskEntities =
        taskModels
            .map(
              (task) => TaskEntity(
                id: task.id,
                systemId: task.systemId,
                name: task.name,
                description: task.description,
                itemDescription: task.itemDescription,
                status: task.status,
                licensePlate: task.licensePlate,
                orderDate: task.orderDate,
                finishingDate: task.finishingDate,
                locationCode: task.locationCode,
                equipmentCode: task.equipmentCode,
                projectCode: task.projectCode,
              ),
            )
            .toList();

    _cachedTasks.clear();
    _cachedTasks.addAll(taskEntities);
    return taskEntities;
  }

  @override
  Future<List<TaskLineEntity>> getTaskLines(String taskId) {
    return remoteDataSource.getTaskLines(taskId);
  }

  @override
  Future<TaskEntity> editTaskStatus(String taskId, TaskStatus status) async {
    final cachedTask = _cachedTasks.firstWhere((task) => task.id == taskId);
    final updatedTaskModel = await remoteDataSource.editTaskStatus(
      cachedTask.systemId,
      TaskStatusMapper.toApiString(status),
    );
    final updatedTask = TaskEntity(
      id: updatedTaskModel.id,
      systemId: updatedTaskModel.systemId,
      name: updatedTaskModel.name,
      description: updatedTaskModel.description,
      itemDescription: updatedTaskModel.itemDescription,
      status: updatedTaskModel.status,
      licensePlate: updatedTaskModel.licensePlate,
      orderDate: updatedTaskModel.orderDate,
      finishingDate: updatedTaskModel.finishingDate,
      locationCode: updatedTaskModel.locationCode,
      equipmentCode: updatedTaskModel.equipmentCode,
      projectCode: updatedTaskModel.projectCode,
    );
    _cachedTasks.removeWhere((task) => task.id == taskId);
    _cachedTasks.add(updatedTask);

    return cachedTask;
  }
}
