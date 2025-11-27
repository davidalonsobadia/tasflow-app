import 'package:taskflow_app/features/images/domain/repositories/image_repository.dart';

class DeleteImageUseCase {
  final ImageRepository repository;

  DeleteImageUseCase(this.repository);

  Future<void> deleteImage(String systemId, String taskId) async {
    await repository.deleteImage(systemId, taskId);
  }
}
