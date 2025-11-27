import 'dart:typed_data';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/images/data/data_sources/image_remote_data_source.dart';
import 'package:taskflow_app/features/images/data/models/image_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of ImageRemoteDataSource for testing without real API
class ImageMockDataSource implements ImageRemoteDataSource {
  final List<ImageModel> _mockImages = [];
  int _nextSystemId = 1;

  ImageMockDataSource() {
    // Initialize with some sample images (empty data for now)
    _mockImages.addAll([
      ImageModel(
        taskId: 'TASK001',
        fileName: 'installation_photo_1',
        fileExtension: 'jpg',
        imageData: Uint8List(0), // Empty placeholder
        systemId: 'img-001',
        documentReferenceID: 'doc-ref-001',
      ),
      ImageModel(
        taskId: 'TASK001',
        fileName: 'installation_photo_2',
        fileExtension: 'png',
        imageData: Uint8List(0), // Empty placeholder
        systemId: 'img-002',
        documentReferenceID: 'doc-ref-002',
      ),
      ImageModel(
        taskId: 'TASK002',
        fileName: 'maintenance_check',
        fileExtension: 'jpg',
        imageData: Uint8List(0), // Empty placeholder
        systemId: 'img-003',
        documentReferenceID: 'doc-ref-003',
      ),
    ]);
    _nextSystemId = 4;
  }

  @override
  Future<List<ImageModel>> getImages(String taskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return _mockImages.where((img) => img.taskId == taskId).toList();
  }

  @override
  Future<ImageModel> addImage(ImageModel image) async {
    // Simulate network delay for upload
    await Future.delayed(const Duration(milliseconds: 1200));

    final newSystemId = 'img-${_nextSystemId.toString().padLeft(3, '0')}';
    final newDocRefId = 'doc-ref-${_nextSystemId.toString().padLeft(3, '0')}';
    
    final newImage = ImageModel(
      taskId: image.taskId,
      fileName: image.fileName,
      fileExtension: image.fileExtension,
      imageData: image.imageData,
      systemId: newSystemId,
      documentReferenceID: newDocRefId,
    );

    _mockImages.add(newImage);
    _nextSystemId++;

    return newImage;
  }

  @override
  Future<void> deleteImage(String systemId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockImages.indexWhere((img) => img.systemId == systemId);
    
    if (index == -1) {
      throw ServerException(
        translate('failedToDeleteImage'),
        null,
      );
    }

    _mockImages.removeAt(index);
  }

  @override
  Future<int> getImagesCount(String taskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockImages.where((img) => img.taskId == taskId).length;
  }
}

