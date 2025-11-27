import 'package:taskflow_app/features/tasks/domain/entities/task_status.dart';

class TaskEntity {
  final String id;
  final String systemId;
  final String name;
  final String description;
  final String itemDescription;
  final TaskStatus status;
  final String licensePlate;
  final String orderDate;
  final String finishingDate;
  final String locationCode;
  final String equipmentCode;
  final String projectCode;

  const TaskEntity({
    required this.id,
    required this.systemId,
    required this.name,
    required this.description,
    required this.itemDescription,
    required this.status,
    required this.licensePlate,
    required this.orderDate,
    required this.finishingDate,
    required this.locationCode,
    required this.equipmentCode,
    required this.projectCode,
  });
}
