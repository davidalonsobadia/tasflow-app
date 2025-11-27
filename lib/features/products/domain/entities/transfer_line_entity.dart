class TransferLineEntity {
  final String id;
  final String productId;
  final double quantity;
  final double? quantityReceived;
  final String taskId;

  const TransferLineEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    this.quantityReceived,
    required this.taskId,
  });
}
