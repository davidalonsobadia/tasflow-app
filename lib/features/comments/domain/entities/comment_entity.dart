class CommentEntity {
  final String taskId;
  final String date;
  final int lineNumber;
  final String message;
  final String? systemId;

  const CommentEntity({
    required this.taskId,
    required this.date,
    required this.lineNumber,
    required this.message,
    this.systemId,
  });
}
