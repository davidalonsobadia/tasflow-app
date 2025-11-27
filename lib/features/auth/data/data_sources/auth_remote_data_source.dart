import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/network/endpoints.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/auth/data/models/user_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class AuthRemoteDataSource {
  Future<bool> isDeviceRegistered(String deviceId);
  Future<UserModel?> getUserIfDeviceRegistered(String deviceId);
  Future<UserModel?> getUserIfValidPassCode(String passCode);
  Future<UserModel> registerDevice(String deviceId, String verificationCode);
  Future<void> unbindDevice(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<bool> isDeviceRegistered(String deviceId) async {
    final queryParams = {"\$filter": "deviceID eq '$deviceId'"};
    final response = await apiClient.get(
      Endpoints.usersEndpoint,
      params: queryParams,
    );

    if (response.statusCode == 200 &&
        response.data['value'] != null &&
        response.data['value'].isNotEmpty) {
      if (response.data['value'].length > 1) {
        throw ValidationException(
          translate('multipleAccountsFoundWithSameDeviceId'),
          Exception(translate('multipleAccountsFoundWithSameDeviceId')),
        );
      }
      return true;
    }

    if (response.statusCode == 404) {
      return false;
    }
    return false;
  }

  @override
  Future<UserModel?> getUserIfDeviceRegistered(String deviceId) async {
    final queryParams = {"\$filter": "deviceID eq '$deviceId'"};
    final response = await apiClient.get(
      Endpoints.usersEndpoint,
      params: queryParams,
    );

    if (response.statusCode == 200 &&
        response.data['value'] != null &&
        response.data['value'].isNotEmpty) {
      if (response.data['value'].length > 1) {
        throw ValidationException(
          translate('multipleAccountsFoundWithSameDeviceId'),
          Exception(translate('multipleAccountsFoundWithSameDeviceId')),
        );
      }
      final userData = response.data['value'][0];
      return UserModel.fromJson(userData);
    }

    return null;
  }

  @override
  Future<UserModel> registerDevice(String userId, String deviceId) async {
    final userIdParam = "('$userId')";
    final body = {"deviceID": deviceId};
    final response = await apiClient.patch(
      Endpoints.usersEndpoint + userIdParam,
      data: body,
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.isNotEmpty) {
      final userData = response.data;
      return UserModel.fromJson(userData);
    }
    throw UnknownException(
      translate('deviceRegistrationFailed'),
      Exception(translate('deviceRegistrationFailed')),
    );
  }

  @override
  Future<UserModel?> getUserIfValidPassCode(String passCode) async {
    final queryParams = {"\$filter": "passcode eq '$passCode'"};
    final response = await apiClient.get(
      Endpoints.usersEndpoint,
      params: queryParams,
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.isNotEmpty) {
      if (response.data['value'].length > 1) {
        throw ValidationException(
          translate('multipleAccountsFoundWithSamePassCode'),
          Exception('multipleAccountsFoundWithSamePassCode'),
        );
      }
      if (response.data['value'].isEmpty) {
        return null;
      }
      final userData = response.data['value'][0];
      return UserModel.fromJson(userData);
    }
    throw UnknownException(
      translate('failedToGetUserWithPasscode'),
      Exception(translate('failedToGetUserWithPasscode')),
    );
  }

  @override
  Future<void> unbindDevice(String userId) async {
    final userIdParam = "('$userId')";
    final body = {"deviceID": ''};
    final response = await apiClient.patch(
      Endpoints.usersEndpoint + userIdParam,
      data: body,
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.isNotEmpty) {
      return;
    }
    throw UnknownException(
      translate('deviceUnbindingFailed'),
      Exception(translate('deviceUnbindingFailed')),
    );
  }
}
