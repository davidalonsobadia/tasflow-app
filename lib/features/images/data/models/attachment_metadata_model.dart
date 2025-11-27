/// Model for attachment metadata response from the first step of image upload
class AttachmentMetadataModel {
  final String systemId;
  final String taskId;
  final String fileName;
  final String fileExtension;
  final String? documentReferenceID;

  const AttachmentMetadataModel({
    required this.systemId,
    required this.taskId,
    required this.fileName,
    required this.fileExtension,
    this.documentReferenceID,
  });

  factory AttachmentMetadataModel.fromJson(Map<String, dynamic> json) {
    return AttachmentMetadataModel(
      systemId: json['systemId'] ?? '',
      taskId: json['no'] ?? '',
      fileName: json['fileName'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      documentReferenceID: json['documentReferenceID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': taskId,
      'fileName': fileName,
      'fileExtension': fileExtension,
    };
  }
}
