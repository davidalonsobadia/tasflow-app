import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  TaskLoaded(this.tasks);
}

class Unauthenticated extends TaskState {}

class TaskFailure extends TaskState {
  final AppError error;
  TaskFailure(this.error);
}
