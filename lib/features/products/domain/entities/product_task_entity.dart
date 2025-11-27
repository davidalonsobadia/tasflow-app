class ProductTaskEntity {
  final String id;
  final String taskId;
  final String name;
  final String description;
  final double quantity;
  final String unit;
  final int lineNumber;
  final String locationCode;
  final String serviceItemNo;
  final int serviceItemLineNo;
  final String type;
  final String? systemId;

  const ProductTaskEntity({
    required this.id,
    required this.taskId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.lineNumber,
    required this.locationCode,
    required this.serviceItemNo,
    required this.serviceItemLineNo,
    required this.type,
    this.systemId,
  });
}
