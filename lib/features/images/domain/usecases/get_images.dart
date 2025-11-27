import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/domain/repositories/image_repository.dart';

class GetImagesUseCase {
  final ImageRepository repository;

  GetImagesUseCase(this.repository);

  Future<List<ImageEntity>> getImages(String taskId) async {
    return await repository.getImages(taskId);
  }

  Future<List<ImageEntity>> refreshImages(String taskId) async {
    return await repository.refreshImages(taskId);
  }

  Future<int> getImagesCount(String taskId) async {
    return await repository.getImagesCount(taskId);
  }
}
