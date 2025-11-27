import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';

class TaskStatusMapper {
  static TaskStatus fromApiString(String statusString) {
    if (statusString == 'In_x0020_Process') return TaskStatus.inProgress;
    if (statusString == 'AIT_x0020_Validated') return TaskStatus.validated;
    if (statusString == 'Finished') return TaskStatus.finished;
    if (statusString == 'On_x0020_Hold') return TaskStatus.onHold;
    return TaskStatus.pending; // Default
  }

  static String toApiString(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'In_x0020_Process';
      case TaskStatus.validated:
        return 'AIT_x0020_Validated';
      case TaskStatus.finished:
        return 'Finished';
      case TaskStatus.onHold:
        return 'On_x0020_Hold';
      case TaskStatus.pending:
        return 'Pending';
    }
  }
}
