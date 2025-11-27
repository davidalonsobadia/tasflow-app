import 'dart:convert';
import 'package:flutter/services.dart';

enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String clientId;
  final String clientSecret;
  final String tokenEndpoint;
  final String scope;
  final String companyIdEndpoint;
  final bool useMockData;

  static late AppConfig _instance;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.clientId,
    required this.clientSecret,
    required this.tokenEndpoint,
    required this.scope,
    required this.companyIdEndpoint,
    required this.useMockData,
  });

  static Future<void> initialize(String? flavor) async {
    final env = flavor == 'prod' ? Environment.prod : Environment.dev;
    final configString = await rootBundle.loadString('assets/config/conf.json');
    final configJson = json.decode(configString);

    final envConfig = configJson[env.toString().split('.').last];

    _instance = AppConfig(
      environment: env,
      apiBaseUrl: envConfig['apiBaseUrl'],
      clientId: envConfig['clientId'],
      clientSecret: envConfig['clientSecret'],
      tokenEndpoint: envConfig['tokenEndpoint'],
      scope: envConfig['scope'],
      companyIdEndpoint: envConfig['companyIdEndpoint'],
      useMockData: envConfig['useMockData'] ?? false,
    );
  }

  static AppConfig get instance => _instance;
}
