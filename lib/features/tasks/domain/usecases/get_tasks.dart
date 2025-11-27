import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskEntity>> getAllTasks(String locationCode) {
    return repository.getAllTasks(locationCode);
  }

  Future<List<TaskEntity>> refreshTasks(String locationCode) {
    return repository.refreshTasks(locationCode);
  }
}
