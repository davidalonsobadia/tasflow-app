import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';

extension TaskStatusDomainExtension on TaskStatus {
  String get translationKey {
    switch (this) {
      case TaskStatus.pending:
        return 'task_status_pending';
      case TaskStatus.inProgress:
        return 'task_status_in_progress';
      case TaskStatus.finished:
        return 'task_status_finished';
      case TaskStatus.validated:
        return 'task_status_validated';
      case TaskStatus.onHold:
        return 'task_status_on_hold';
    }
  }
}
