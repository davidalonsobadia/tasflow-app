import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:taskflow_app/features/auth/data/models/user_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of AuthRemoteDataSource for testing without real API
class AuthMockDataSource implements AuthRemoteDataSource {
  // Simulated database of users with email/password support
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'no': 'USER001',
      'name': 'John Doe',
      'email': 'john@example.com',
      'password': 'password123',
      'deviceID': 'mock-device-123',
      'passcode': '1234',
      'locationCode': 'LOC001',
    },
    {
      'no': 'USER002',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'password': 'password456',
      'deviceID': 'mock-device-456',
      'passcode': '5678',
      'locationCode': 'LOC002',
    },
    {
      'no': 'USER003',
      'name': 'Test User',
      'email': 'test@example.com',
      'password': 'test123',
      'deviceID': '',
      'passcode': '9999',
      'locationCode': 'LOC001',
    },
  ];

  // Simulated password reset tokens
  final Map<String, String> _passwordResetTokens = {};

  // Counter for generating user IDs
  int _userIdCounter = 4;

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

  @override
  Future<UserModel?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final users =
        _mockUsers
            .where(
              (u) => u['email'] == email && u['password'] == password,
            )
            .toList();

    if (users.isEmpty) {
      return null;
    }

    return UserModel.fromJson(users.first);
  }

  @override
  Future<UserModel> registerUser(
    String email,
    String password,
    String name,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if email already exists
    final existingUser = _mockUsers.where((u) => u['email'] == email).toList();
    if (existingUser.isNotEmpty) {
      throw ValidationException(
        translate('emailAlreadyRegistered'),
        Exception(translate('emailAlreadyRegistered')),
      );
    }

    // Create new user
    final newUser = {
      'no': 'USER${_userIdCounter++.toString().padLeft(3, '0')}',
      'name': name,
      'email': email,
      'password': password,
      'deviceID': '',
      'passcode': '',
      'locationCode': 'LOC001',
    };

    _mockUsers.add(newUser);
    return UserModel.fromJson(newUser);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if email exists
    final users = _mockUsers.where((u) => u['email'] == email).toList();
    if (users.isEmpty) {
      // For security reasons, we don't reveal if email exists
      // Just pretend the request was successful
      return;
    }

    // Generate a mock reset token
    final token = 'RESET_${DateTime.now().millisecondsSinceEpoch}';
    _passwordResetTokens[email] = token;

    // In real implementation, this would send an email
    // For mock, we just store the token
  }

  @override
  Future<void> resetPassword(
    String email,
    String newPassword,
    String token,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // For mock purposes, we'll accept any token that matches
    // In a real implementation, this would validate the token properly
    final storedToken = _passwordResetTokens[email];

    // For testing purposes, also accept 'MOCK_TOKEN' as valid
    if (storedToken != token && token != 'MOCK_TOKEN') {
      throw ValidationException(
        translate('invalidResetToken'),
        Exception(translate('invalidResetToken')),
      );
    }

    // Find and update user's password
    final userIndex = _mockUsers.indexWhere((u) => u['email'] == email);
    if (userIndex == -1) {
      throw ValidationException(
        translate('userNotFound'),
        Exception(translate('userNotFound')),
      );
    }

    _mockUsers[userIndex]['password'] = newPassword;
    _passwordResetTokens.remove(email);
  }
}

