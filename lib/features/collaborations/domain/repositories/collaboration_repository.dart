import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';

abstract class CollaborationRepository {
  Future<void> uploadCollaboration(CollaborationEntity collaboration);
}
