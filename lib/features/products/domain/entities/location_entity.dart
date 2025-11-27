class LocationEntity {
  final String code;
  final String name;
  final String consumptionLocationCode;
  final bool requiresTransferOrder;

  const LocationEntity({
    required this.code,
    required this.name,
    required this.consumptionLocationCode,
    required this.requiresTransferOrder,
  });
}
