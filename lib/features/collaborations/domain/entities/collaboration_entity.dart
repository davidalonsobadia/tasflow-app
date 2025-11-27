class CollaborationEntity {
  final String taskId;
  final String userId;
  final String startingDateTime;
  final String endingDateTime;
  final String comment;

  const CollaborationEntity({
    required this.taskId,
    required this.userId,
    required this.startingDateTime,
    required this.endingDateTime,
    required this.comment,
  });
}
