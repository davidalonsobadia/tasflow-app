import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_line_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getAllTasks(String locationCode);
  Future<List<TaskEntity>> refreshTasks(String lcoationCode);
  Future<TaskEntity> editTaskStatus(String taskId, TaskStatus status);

  Future<List<TaskLineEntity>> getTaskLines(String taskId);
}
