import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:taskflow_app/features/auth/data/models/user_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of AuthRemoteDataSource for testing without real API
class AuthMockDataSource implements AuthRemoteDataSource {
  // Simulated database of users
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'no': 'USER001',
      'name': 'John Doe',
      'deviceID': 'mock-device-123',
      'passcode': '1234',
      'locationCode': 'LOC001',
    },
    {
      'no': 'USER002',
      'name': 'Jane Smith',
      'deviceID': 'mock-device-456',
      'passcode': '5678',
      'locationCode': 'LOC002',
    },
    {
      'no': 'USER003',
      'name': 'Test User',
      'deviceID': '',
      'passcode': '9999',
      'locationCode': 'LOC001',
    },
  ];

  @override
  Future<bool> isDeviceRegistered(String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _mockUsers.where((u) => u['deviceID'] == deviceId).toList();
    
    if (user.length > 1) {
      throw ValidationException(
        translate('multipleAccountsFoundWithSameDeviceId'),
        Exception(translate('multipleAccountsFoundWithSameDeviceId')),
      );
    }
    
    return user.isNotEmpty;
  }

  @override
  Future<UserModel?> getUserIfDeviceRegistered(String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final users = _mockUsers.where((u) => u['deviceID'] == deviceId).toList();
    
    if (users.length > 1) {
      throw ValidationException(
        translate('multipleAccountsFoundWithSameDeviceId'),
        Exception(translate('multipleAccountsFoundWithSameDeviceId')),
      );
    }
    
    if (users.isEmpty) {
      return null;
    }
    
    return UserModel.fromJson(users.first);
  }

  @override
  Future<UserModel> registerDevice(String userId, String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final userIndex = _mockUsers.indexWhere((u) => u['no'] == userId);
    
    if (userIndex == -1) {
      throw UnknownException(
        translate('deviceRegistrationFailed'),
        Exception(translate('deviceRegistrationFailed')),
      );
    }
    
    // Update the mock user's device ID
    _mockUsers[userIndex]['deviceID'] = deviceId;
    
    return UserModel.fromJson(_mockUsers[userIndex]);
  }

  @override
  Future<UserModel?> getUserIfValidPassCode(String passCode) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final users = _mockUsers.where((u) => u['passcode'] == passCode).toList();
    
    if (users.length > 1) {
      throw ValidationException(
        translate('multipleAccountsFoundWithSamePassCode'),
        Exception('multipleAccountsFoundWithSamePassCode'),
      );
    }
    
    if (users.isEmpty) {
      return null;
    }
    
    return UserModel.fromJson(users.first);
  }

  @override
  Future<void> unbindDevice(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final userIndex = _mockUsers.indexWhere((u) => u['no'] == userId);
    
    if (userIndex == -1) {
      throw UnknownException(
        translate('deviceUnbindingFailed'),
        Exception(translate('deviceUnbindingFailed')),
      );
    }
    
    // Clear the device ID
    _mockUsers[userIndex]['deviceID'] = '';
  }
}

