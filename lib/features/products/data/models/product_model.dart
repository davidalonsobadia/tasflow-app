import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'dart:convert';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.systemId,
    required super.name,
    required super.description,
    required super.inventory,
    required super.unit,
    required super.inventoriesByLocation,
    required super.group,
    required super.vendorName,
    required super.type,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['no'],
      systemId: json['systemId'],
      name: json['description'],
      description: json['searchDescription'],
      inventory: _parseInventoryAsDouble(json['inventory']),
      unit: json['baseUnitOfMeasure'],
      inventoriesByLocation: _getInventoriesByLocation(json['locations']),
      group: json['inventoryPostingGroup'],
      vendorName: json['vendorName'],
      type: json['type'],
    );
  }

  static List<InventoryByLocation> _getInventoriesByLocation(
    String? rawLocations,
  ) {
    List<InventoryByLocation> inventoriesByLocation = [];

    // we need to transform an String like this: "[{\"locationCode\":\"TALLERGAVA\",\"displayName\":\"Taller Gavá\",\"inventory\":0},{\"locationCode\":\"TALLERMAD\",\"displayName\":\"Taller Madrid\",\"inventory\":0},{\"locationCode\":\"MADRID\",\"displayName\":\"Almacén Madrid\",\"inventory\":0}]"
    if (rawLocations != null && rawLocations.isNotEmpty) {
      try {
        // Remove escape characters and parse the string
        String cleanedString = rawLocations.replaceAll('\\', '');
        // Replace commas in numbers with periods
        cleanedString = rawLocations.replaceAllMapped(
          RegExp(r'(-?\d),(\d)'),
          (match) => '${match.group(1)}.${match.group(2)}',
        );
        // Decode the cleaned string
        List<dynamic> locationsList = jsonDecode(cleanedString);

        for (var location in locationsList) {
          if (location is Map) {
            String locationCode = location['locationCode'];
            String displayName = location['displayName'];
            var rawQuantity = location['inventory'];
            final quantity = _parseInventoryAsDouble(rawQuantity);

            inventoriesByLocation.add(
              InventoryByLocation(
                displayName: displayName,
                locationCode: locationCode,
                quantity: quantity,
              ),
            );
          }
        }
      } catch (e) {
        print('Error parsing inventory locations: $e');
      }
    }
    return inventoriesByLocation;
  }

  static double _parseInventoryAsDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }
}
