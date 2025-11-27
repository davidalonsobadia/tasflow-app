import 'package:taskflow_app/features/comments/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.taskId,
    required super.date,
    required super.lineNumber,
    required super.message,
    super.systemId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      taskId: json['no'],
      date: json['date'],
      lineNumber: json['lineNo'],
      message: json['comment'],
      systemId: json['SystemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': taskId,
      'date': date,
      'lineNo': lineNumber,
      'comment': message,
    };
  }
}
