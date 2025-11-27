import 'package:taskflow_app/features/tasks/domain/entities/task_line_entity.dart';

class TaskLineModel extends TaskLineEntity {
  const TaskLineModel({
    required super.taskId,
    required super.serviceItemNo,
    required super.lineNumber,
  });

  factory TaskLineModel.fromJson(Map<String, dynamic> json) {
    return TaskLineModel(
      taskId: json['documentNo'],
      serviceItemNo: json['serviceItemNo'],
      lineNumber: json['lineNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNo': taskId,
      'serviceItemNo': serviceItemNo,
      'lineNo': lineNumber,
    };
  }
}
