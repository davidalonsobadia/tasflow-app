import 'package:taskflow_app/features/images/data/data_sources/image_remote_data_source.dart';
import 'package:taskflow_app/features/images/data/models/image_model.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource imageRemoteDataSource;

  ImageRepositoryImpl({required this.imageRemoteDataSource});

  // Cache the images to avoid unnecessary reloads
  // Key: Task ID, Value: List of images for that task
  final Map<String, List<ImageEntity>> _cachedImages = {};

  @override
  Future<List<ImageEntity>> getImages(String taskId) async {
    // Return cached images if available
    if (_cachedImages.containsKey(taskId) &&
        _cachedImages[taskId]!.isNotEmpty) {
      return _cachedImages[taskId]!;
    }

    final images = await imageRemoteDataSource
        .getImages(taskId)
        .then(
          (images) =>
              images
                  .map(
                    (image) => ImageEntity(
                      taskId: image.taskId,
                      fileName: image.fileName,
                      fileExtension: image.fileExtension,
                      imageData: image.imageData,
                      systemId: image.systemId,
                      documentReferenceID: image.documentReferenceID,
                    ),
                  )
                  .toList(),
        );

    // Update cache
    _cachedImages[taskId] = images;
    return images;
  }

  @override
  Future<ImageEntity> addImage(ImageEntity image) async {
    // Optimistic update: Add uploading image to cache immediately
    final uploadingImage = image.copyWith(isUploading: true);
    if (_cachedImages[image.taskId] == null) {
      _cachedImages[image.taskId] = [uploadingImage];
    } else {
      _cachedImages[image.taskId]!.add(uploadingImage);
    }

    try {
      final response = await imageRemoteDataSource.addImage(
        ImageModel(
          taskId: image.taskId,
          fileName: image.fileName,
          fileExtension: image.fileExtension,
          imageData: image.imageData,
          systemId: image.systemId,
          documentReferenceID: image.documentReferenceID,
        ),
      );

      // Create final image with all API data (systemId, documentReferenceID)
      final newImage = ImageEntity(
        taskId: response.taskId,
        fileName: response.fileName,
        fileExtension: response.fileExtension,
        imageData: response.imageData,
        systemId: response.systemId, // From API response
        documentReferenceID: response.documentReferenceID, // From API response
        isUploading: false,
      );

      // Replace uploading placeholder with real image in cache
      if (_cachedImages[image.taskId] != null) {
        final index = _cachedImages[image.taskId]!.indexWhere(
          (img) => img.fileName == uploadingImage.fileName && img.isUploading,
        );
        if (index != -1) {
          _cachedImages[image.taskId]![index] = newImage;
        } else {
          _cachedImages[image.taskId]!.add(newImage);
        }
      }

      return newImage;
    } catch (e) {
      // Rollback: Remove uploading placeholder on failure
      if (_cachedImages[image.taskId] != null) {
        _cachedImages[image.taskId]!.removeWhere(
          (img) => img.fileName == uploadingImage.fileName && img.isUploading,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteImage(String systemId, String taskId) async {
    // Optimistic update: Remove image from cache immediately
    ImageEntity? deletedImage;
    if (_cachedImages.containsKey(taskId)) {
      final index = _cachedImages[taskId]!.indexWhere(
        (image) => image.systemId == systemId,
      );
      if (index != -1) {
        deletedImage = _cachedImages[taskId]![index];
        _cachedImages[taskId]!.removeAt(index);
      }
    }

    try {
      await imageRemoteDataSource.deleteImage(systemId);
      // Success: Keep cache as-is (image already removed optimistically)
    } catch (e) {
      // Rollback: Re-add the deleted image to cache on failure
      if (deletedImage != null && _cachedImages.containsKey(taskId)) {
        _cachedImages[taskId]!.add(deletedImage);
      }
      rethrow;
    }
  }

  @override
  Future<List<ImageEntity>> refreshImages(String taskId) async {
    final images = await imageRemoteDataSource
        .getImages(taskId)
        .then(
          (images) =>
              images
                  .map(
                    (image) => ImageEntity(
                      taskId: image.taskId,
                      fileName: image.fileName,
                      fileExtension: image.fileExtension,
                      imageData: image.imageData,
                      systemId: image.systemId,
                      documentReferenceID: image.documentReferenceID,
                    ),
                  )
                  .toList(),
        );

    _cachedImages[taskId] = images;
    return images;
  }

  @override
  Future<int> getImagesCount(String taskId) async {
    return await imageRemoteDataSource.getImagesCount(taskId);
  }
}
