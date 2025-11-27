class TransferReceiptLineEntity {
  final String documentNo;
  final String transferFromCode;
  final String transferToCode;
  final String taskId;
  final String productId;

  const TransferReceiptLineEntity({
    required this.documentNo,
    required this.transferFromCode,
    required this.transferToCode,
    required this.taskId,
    required this.productId,
  });
}
