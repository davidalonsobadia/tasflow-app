import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';

class CollaborationModel extends CollaborationEntity {
  const CollaborationModel({
    required super.taskId,
    required super.userId,
    required super.startingDateTime,
    required super.endingDateTime,
    required super.comment,
  });

  factory CollaborationModel.fromJson(Map<String, dynamic> json) {
    return CollaborationModel(
      taskId: json['documentNo'],
      userId: json['userID'],
      startingDateTime: json['startingDateTime'],
      endingDateTime: json['endingDateTime'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNo': taskId,
      'userID': userId,
      'startingDateTime': startingDateTime,
      'endingDateTime': endingDateTime,
      'comment': comment,
    };
  }
}
