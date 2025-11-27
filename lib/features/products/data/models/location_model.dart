import 'package:taskflow_app/features/products/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.code,
    required super.name,
    required super.consumptionLocationCode,
    required super.requiresTransferOrder,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      consumptionLocationCode: json['consumptionLocationCode'] ?? '',
      requiresTransferOrder: json['doTransferOrders'] ?? false,
    );
  }
}
