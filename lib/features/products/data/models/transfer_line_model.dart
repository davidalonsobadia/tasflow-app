import 'package:taskflow_app/features/products/domain/entities/transfer_line_entity.dart';

class TransferLineModel extends TransferLineEntity {
  const TransferLineModel({
    required super.id,
    required super.productId,
    required super.quantity,
    super.quantityReceived,
    required super.taskId,
  });

  factory TransferLineModel.fromJson(Map<String, dynamic> json) {
    return TransferLineModel(
      id: json['documentNo'] ?? '',
      productId: json['itemNo'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      quantityReceived: (json['quantityReceived'] as num?)?.toDouble() ?? 0.0,
      taskId: json['serviceOrderNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNo': id,
      'itemNo': productId,
      'quantity': quantity,
      'serviceOrderNo': taskId,
    };
  }
}
