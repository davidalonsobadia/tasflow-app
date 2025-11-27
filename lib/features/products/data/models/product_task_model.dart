import 'package:taskflow_app/features/products/domain/entities/product_task_entity.dart';

class ProductTaskModel extends ProductTaskEntity {
  const ProductTaskModel({
    required super.id,
    required super.taskId,
    required super.name,
    required super.description,
    required super.quantity,
    required super.unit,
    required super.lineNumber,
    required super.locationCode,
    required super.serviceItemNo,
    required super.serviceItemLineNo,
    required super.type,
    super.systemId,
  });

  factory ProductTaskModel.fromJson(Map<String, dynamic> json) {
    return ProductTaskModel(
      id: json['no'],
      taskId: json['documentNo'],
      serviceItemNo: json['serviceItemNo'],
      serviceItemLineNo: json['serviceItemLineNo'],
      lineNumber: json['lineNo'],
      name: json['description'],
      description: json['description'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unitOfMeasure'],
      type: json['type'],
      locationCode: json['locationCode'],
      systemId: json['systemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentType': 'Order',
      'documentNo': taskId,
      'lineNo': lineNumber,
      'serviceItemLineNo': serviceItemLineNo,
      'type': type,
      'no': id,
      'locationCode': locationCode,
      'quantity': quantity,
    };
  }
}
