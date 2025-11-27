import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/domain/repositories/task_repository.dart';

class EditTasksUseCase {
  final TaskRepository repository;

  EditTasksUseCase(this.repository);

  Future<TaskEntity> editTaskStatus(String taskId, TaskStatus status) {
    return repository.editTaskStatus(taskId, status);
  }
}
