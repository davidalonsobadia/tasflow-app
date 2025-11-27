import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow_app/features/tasks/domain/usecases/edit_tasks.dart';
import 'package:taskflow_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> with ErrorReportingMixin {
  final GetTasksUseCase getTasksUseCase;
  final EditTasksUseCase editTasksUseCase;

  TaskCubit(this.getTasksUseCase, this.editTasksUseCase) : super(TaskInitial());

  Future<void> getAllTasks(String locationCode) async {
    if (state is TaskLoading) {
      return;
    }

    emit(TaskLoading());

    try {
      final tasks = await getTasksUseCase.getAllTasks(locationCode);
      emit(TaskLoaded(tasks));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - critical operation
        context: 'getAllTasks',
      );
      emit(TaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> refreshTasks(String locationCode) async {
    emit(TaskLoading());

    try {
      final tasks = await getTasksUseCase.refreshTasks(locationCode);
      emit(TaskLoaded(tasks));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - critical operation
        context: 'refreshTasks',
      );
      emit(TaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> startTaskIfNotStarted({
    required TaskEntity task,
    required String locationCode,
  }) async {
    if (task.status != TaskStatus.pending) {
      return;
    }

    try {
      await editTasksUseCase.editTaskStatus(task.id, TaskStatus.inProgress);
      await getAllTasks(locationCode);
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'startTaskIfNotStarted',
      );
      emit(TaskFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> editTaskStatus(
    TaskEntity task,
    TaskStatus status,
    String locationCode,
  ) async {
    try {
      await editTasksUseCase.editTaskStatus(task.id, status);
      await getAllTasks(locationCode);
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'editTaskStatus',
      );
      emit(TaskFailure(ErrorHandler.handle(exception)));
    }
  }
}
