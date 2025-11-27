import 'dart:convert';
import 'package:taskflow_app/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';

class HttpApiClient {
  late SharedPreferences _prefs;
  final String baseUrl = Endpoints.baseUrl;

  // Print request details
  void _logRequest(
    String method,
    String url,
    Map<String, String>? headers,
    dynamic body,
  ) {
    print('🚀 REQUEST: $method $url');
    print('🔤 HEADERS: $headers');
    if (body != null) {
      print('📦 BODY: $body');
    }
  }

  // Print response details
  void _logResponse(http.Response response) {
    print('📥 RESPONSE: [${response.statusCode}] ${response.request?.url}');
    print('🔤 HEADERS: ${response.headers}');
    print('📦 BODY: ${response.body}');
  }

  // GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getAuthHeaders(headers);

    _logRequest('GET', url.toString(), requestHeaders, null);

    final response = await http.get(url, headers: requestHeaders);
    _logResponse(response);

    return response;
  }

  // POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getAuthHeaders(headers);
    final encodedBody = json.encode(body);

    _logRequest('POST', url.toString(), requestHeaders, encodedBody);

    final response = await http.post(
      url,
      headers: requestHeaders,
      body: encodedBody,
    );
    _logResponse(response);

    return response;
  }

  // Helper to add auth token to headers
  Future<Map<String, String>> _getAuthHeaders(
    Map<String, String>? headers,
  ) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('access_token');

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    return requestHeaders;
  }

  // Get access token
  Future<bool> getAccessToken() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('$baseUrl${Endpoints.token}');

      final config = AppConfig.instance;
      String username = config.clientId;
      String password = config.clientSecret;
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      final headers = {
        "Authorization": basicAuth,
        "Content-Type": "application/x-www-form-urlencoded",
      };

      final body = {"grant_type": "client_credentials", "scope": config.scope};

      _logRequest('POST', url.toString(), headers, body);

      final response = await http.post(url, headers: headers, body: body);

      _logResponse(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String newToken = data['access_token'];
        int expiresIn = data['expires_in'];
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
}
