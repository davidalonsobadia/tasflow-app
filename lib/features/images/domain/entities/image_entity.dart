import 'dart:typed_data';

class ImageEntity {
  final String taskId;
  final String fileName;
  final String fileExtension;
  final Uint8List imageData;
  final String systemId;
  final String? documentReferenceID;
  final bool isUploading;

  const ImageEntity({
    required this.taskId,
    required this.fileName,
    required this.fileExtension,
    required this.imageData,
    required this.systemId,
    this.documentReferenceID,
    this.isUploading = false,
  });

  ImageEntity copyWith({
    String? taskId,
    String? fileName,
    String? fileExtension,
    Uint8List? imageData,
    String? systemId,
    String? documentReferenceID,
    bool? isUploading,
  }) {
    return ImageEntity(
      taskId: taskId ?? this.taskId,
      fileName: fileName ?? this.fileName,
      fileExtension: fileExtension ?? this.fileExtension,
      imageData: imageData ?? this.imageData,
      systemId: systemId ?? this.systemId,
      documentReferenceID: documentReferenceID ?? this.documentReferenceID,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
