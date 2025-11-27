import 'dart:io';
import 'dart:typed_data';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/domain/repositories/image_repository.dart';

class AddImagesUseCase {
  final ImageRepository repository;

  AddImagesUseCase(this.repository);

  Future<ImageEntity> addImageFromTaskIdAndFilePath(
    String taskId,
    String filePath,
  ) async {
    // Extract file extension
    final String fileExtension = filePath.split('.').last;
    // Generate filename with timestamp
    final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    // Read file as binary data
    final File imageFile = File(filePath);
    final Uint8List imageBytes = imageFile.readAsBytesSync();
    // Create image entity
    final image = ImageEntity(
      taskId: taskId,
      fileName: fileName,
      fileExtension: fileExtension,
      imageData: imageBytes,
      systemId: '',
    );

    return await repository.addImage(image);
  }
}
