import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.deviceId,
    required super.passCode,
    required super.location,
    super.collaboratingWorkshop = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['no'],
      name: json['name'],
      deviceId: json['deviceID'],
      passCode: json['passcode'],
      location: json['locationCode'],
      collaboratingWorkshop: json['collaboratingWorkshop'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': id,
      'name': deviceId,
      'deviceID': deviceId,
      'passcode': passCode,
      'collaboratingWorkshop': collaboratingWorkshop,
    };
  }
}
