import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';
import 'package:taskflow_app/features/collaborations/domain/repositories/collaboration_repository.dart';

class UploadCollaborationUseCase {
  final CollaborationRepository repository;

  UploadCollaborationUseCase(this.repository);

  Future<void> uploadCollaboration(CollaborationEntity collaboration) {
    return repository.uploadCollaboration(collaboration);
  }
}
