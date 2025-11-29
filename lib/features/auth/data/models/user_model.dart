import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.deviceId,
    required super.passCode,
    required super.location,
    super.collaboratingWorkshop = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['no'],
      name: json['name'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      deviceId: json['deviceID'],
      passCode: json['passcode'],
      location: json['locationCode'],
      collaboratingWorkshop: json['collaboratingWorkshop'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': id,
      'name': name,
      'email': email,
      'password': password,
      'deviceID': deviceId,
      'passcode': passCode,
      'locationCode': location,
      'collaboratingWorkshop': collaboratingWorkshop,
    };
  }
}
