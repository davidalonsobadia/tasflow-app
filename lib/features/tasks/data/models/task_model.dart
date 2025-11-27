import 'package:taskflow_app/features/tasks/data/models/mappers/task_status_mapper.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.systemId,
    required super.name,
    required super.description,
    required super.itemDescription,
    required super.status,
    required super.licensePlate,
    required super.orderDate,
    required super.finishingDate,
    required super.locationCode,
    required super.equipmentCode,
    required super.projectCode,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['no'],
      systemId: json['systemId'],
      name: json['name'],
      description: json['description'] ?? '',
      itemDescription: json['itemDescription'] ?? '',
      status: TaskStatusMapper.fromApiString(json['status']),
      licensePlate: json['aitLicensePlate'],
      orderDate: json['orderDate'],
      finishingDate: json['finishingDate'],
      locationCode: json['locationCode'],
      equipmentCode: json['shortcutDimension1Code'],
      projectCode: json['shortcutDimension2Code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskID': id,
      'name': name,
      'description': description,
      'status': TaskStatusMapper.toApiString(status),
    };
  }
}
