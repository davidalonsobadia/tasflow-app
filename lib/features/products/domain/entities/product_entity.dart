class ProductEntity {
  final String id;
  final String systemId;
  final String name;
  final String description;
  final double inventory;
  final String unit;
  final List<InventoryByLocation> inventoriesByLocation;
  final String group;
  final String vendorName;
  final String type;

  const ProductEntity({
    required this.id,
    required this.systemId,
    required this.name,
    required this.description,
    required this.inventory,
    required this.unit,
    required this.inventoriesByLocation,
    required this.group,
    required this.vendorName,
    required this.type,
  });
}

class InventoryByLocation {
  final String locationCode;
  final String displayName;
  final double quantity;

  const InventoryByLocation({required this.displayName, required this.locationCode, required this.quantity});
}
