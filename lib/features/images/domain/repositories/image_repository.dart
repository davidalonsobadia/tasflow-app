import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<List<ImageEntity>> getImages(String taskId);
  Future<ImageEntity> addImage(ImageEntity image);
  Future<void> deleteImage(String systemId, String taskId);
  Future<List<ImageEntity>> refreshImages(String taskId);
  Future<int> getImagesCount(String taskId);
}
