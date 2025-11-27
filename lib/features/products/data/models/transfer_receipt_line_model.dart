import 'package:taskflow_app/features/products/domain/entities/transfer_receipt_line_entity.dart';

class TransferReceiptLineModel extends TransferReceiptLineEntity {
  const TransferReceiptLineModel({
    required super.documentNo,
    required super.transferFromCode,
    required super.transferToCode,
    required super.taskId,
    required super.productId,
  });

  factory TransferReceiptLineModel.fromJson(Map<String, dynamic> json) {
    return TransferReceiptLineModel(
      documentNo: json['documentNo'] ?? '',
      productId: json['itemNo'] ?? '',
      transferFromCode: json['transferFromCode'] ?? '',
      transferToCode: json['transferToCode'] ?? '',
      taskId: json['serviceOrderNo'] ?? '',
    );
  }
}
