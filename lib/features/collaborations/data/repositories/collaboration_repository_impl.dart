import 'package:taskflow_app/features/collaborations/data/data_sources/collaboration_remote_data_source.dart';
import 'package:taskflow_app/features/collaborations/data/models/collaboration_model.dart';
import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';
import 'package:taskflow_app/features/collaborations/domain/repositories/collaboration_repository.dart';

class CollaborationRepositoryImpl implements CollaborationRepository {
  final CollaborationRemoteDataSource remoteDataSource;

  CollaborationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> uploadCollaboration(CollaborationEntity collaboration) async {
    remoteDataSource.uploadCollaboration(
      CollaborationModel(
        taskId: collaboration.taskId,
        userId: collaboration.userId,
        startingDateTime: collaboration.startingDateTime,
        endingDateTime: collaboration.endingDateTime,
        comment: collaboration.comment,
      ),
    );
  }
}
