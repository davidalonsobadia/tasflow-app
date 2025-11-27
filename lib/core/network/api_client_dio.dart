import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';
import 'package:taskflow_app/config/app_config.dart';
import 'package:taskflow_app/core/network/mock_interceptor.dart';

class DioApiClient {
  late SharedPreferences _prefs;

  late Dio _dioForAuth;
  late Dio _dioForApi;

  // Add the mock interceptor
  final MockErrorInterceptor mockInterceptor = MockErrorInterceptor();

  DioApiClient() {
    _dioForAuth = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    _dioForApi = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrlWithCompany,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    // Add logging interceptor to auth client if in dev mode
    if (AppConfig.instance.environment == Environment.dev) {
      _dioForAuth.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) {
            print('🔐 AUTH: $object');
          },
        ),
      );
    }

    // Add logging interceptor to API client if in dev mode
    if (AppConfig.instance.environment == Environment.dev) {
      _dioForApi.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) {
            print('🌐 API: $object');
          },
        ),
      );
    }

    // Add mock interceptor to API client
    if (AppConfig.instance.environment == Environment.dev && Platform.isIOS) {
      _dioForApi.interceptors.add(mockInterceptor);
    }

    _dioForApi.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _prefs = await SharedPreferences.getInstance();
          final token = _prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          //for patch
          if (options.method == 'PATCH') {
            options.headers['If-Match'] = '*';
            options.headers['Content-Type'] = 'application/json';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 ||
              _isAuthenticationChallengeMalformed(error)) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request with the new token
              _prefs = await SharedPreferences.getInstance();
              final token = _prefs.getString('access_token');
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final retryResponse = await _dioForApi.request(
                error.requestOptions.path,
                options: Options(method: error.requestOptions.method),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(retryResponse);
            }
          }
          DioException exception = error.copyWith(
            message: translate('unexpectedErrorContactAdmin'),
          );
          return handler.next(exception);
        },
      ),
    );
  }

  // Add methods to control the mock interceptor
  void enableMockErrors(bool enable) {
    mockInterceptor.setEnabled(enable);
  }

  void configureMockError({required ErrorType type, double probability = 1.0}) {
    mockInterceptor.configure(type: type, probability: probability);
  }

  Future<bool> _refreshToken() async {
    try {
      final expiryTime = _prefs.getInt('token_expiry');
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final marginTime = 1000 * 10; // 10 seconds margin

      if (expiryTime == null || expiryTime < (currentTime + marginTime)) {
        return await _getAccessToken(); // Get a new token
      }
    } catch (e) {
      print("Failed to refresh token: $e");
    }
    return false;
  }

  Future<bool> _getAccessToken() async {
    try {
      final config = AppConfig.instance;
      final response = await _dioForAuth.post(
        Endpoints.token,
        options: Options(
          headers: {
            "Authorization":
                'Basic ${base64Encode(utf8.encode('${config.clientId}:${config.clientSecret}'))}',
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
        data: {"grant_type": "client_credentials", "scope": config.scope},
      );

      if (response.statusCode == 200) {
        String newToken = response.data['access_token'];
        int expiresIn = response.data['expires_in'];
        await _prefs.setString('access_token', newToken);
        await _prefs.setInt(
          'token_expiry',
          DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000),
        );
        return true;
      }
    } catch (e) {
      print("Token refresh failed: $e");
    }
    return false;
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    return await _dioForApi.post(endpoint, data: data);
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return await _dioForApi.get(
      endpoint,
      queryParameters: params,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patch(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
  }) async {
    return await _dioForApi.patch(
      endpoint,
      queryParameters: params,
      data: data,
    );
  }

  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    return await _dioForApi.delete(endpoint, queryParameters: params);
  }

  /// PUT request for binary data upload with specific headers
  Future<Response> putBinary(
    String endpoint,
    Uint8List data, {
    String contentType = 'image/jpeg',
  }) async {
    return await _dioForApi.put(
      endpoint,
      data: data,
      options: Options(
        requestEncoder: (final request, final options) {
          return data;
        },
        headers: {
          'If-Match': '*',
          'Content-Type': contentType,
          'Content-Length': '${data.length}',
        },
      ),
    );
  }

  /// GET request for binary data download
  Future<Response> getBinary(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    return await _dioForApi.get(
      endpoint,
      queryParameters: params,
      options: Options(responseType: ResponseType.bytes),
    );
  }

  bool _isAuthenticationChallengeMalformed(DioException dioException) {
    var error = dioException.error;
    if (error is HttpException) {
      return error.message.contains(
        'The authentication challenge sent by the server is not correctly formatted.',
      );
    }
    return false;
  }
}
