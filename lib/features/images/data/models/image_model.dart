import 'dart:typed_data';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.taskId,
    required super.fileName,
    required super.fileExtension,
    required super.imageData,
    required super.systemId,
    super.documentReferenceID,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      taskId: json['no'] ?? '',
      fileName: json['fileName'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      imageData: Uint8List(0), // Will be populated separately in new flow
      systemId: json['systemId'] ?? '',
      documentReferenceID: json['documentReferenceID'],
    );
  }

  /// Factory for creating from attachment metadata (step 1 response)
  factory ImageModel.fromAttachmentMetadata(Map<String, dynamic> json) {
    return ImageModel(
      taskId: json['no'] ?? '',
      fileName: json['fileName'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      imageData: Uint8List(0), // Will be populated in step 2
      systemId: json['systemId'] ?? '',
      documentReferenceID: json['documentReferenceID'],
    );
  }

  /// Create a copy with binary data
  ImageModel copyWithImageData(Uint8List imageData) {
    return ImageModel(
      taskId: taskId,
      fileName: fileName,
      fileExtension: fileExtension,
      imageData: imageData,
      systemId: systemId,
      documentReferenceID: documentReferenceID,
    );
  }

  Map<String, dynamic> toJson() {
    return {'no': taskId, 'fileName': fileName, 'fileExtension': fileExtension};
  }
}
