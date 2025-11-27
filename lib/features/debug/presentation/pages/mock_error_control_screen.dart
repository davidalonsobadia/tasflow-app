import 'dart:io';

import 'package:taskflow_app/config/app_config.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/di/service_locator.dart';
import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockErrorControlScreen extends StatefulWidget {
  // only mock for iOS and dev environment
  static bool shouldShow() {
    final appConfig = AppConfig.instance;
    return appConfig.environment == Environment.dev && Platform.isIOS;
  }

  const MockErrorControlScreen({super.key});

  @override
  State<MockErrorControlScreen> createState() => _MockErrorControlScreenState();
}

class _MockErrorControlScreenState extends State<MockErrorControlScreen> {
  final DioApiClient _apiClient = sl<DioApiClient>();
  bool _mockEnabled = false;
  ErrorType _selectedErrorType = ErrorType.network;
  double _errorProbability = 1.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mockEnabled = prefs.getBool('mock_error_enabled') ?? false;
      final typeIndex = prefs.getInt('mock_error_type') ?? 0;
      _selectedErrorType = ErrorType.values[typeIndex];
      _errorProbability = prefs.getDouble('mock_error_probability') ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Error Control')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enable/disable switch
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Enable Mock Errors',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: _mockEnabled,
                        onChanged: (value) {
                          setState(() {
                            _mockEnabled = value;
                            _apiClient.enableMockErrors(value);
                          });
                        },
                        activeThumbColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Error type selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Error Type:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<ErrorType>(
                        isExpanded: true,
                        value: _selectedErrorType,
                        onChanged:
                            _mockEnabled
                                ? (ErrorType? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedErrorType = newValue;
                                      _updateMockConfiguration();
                                    });
                                  }
                                }
                                : null,
                        items:
                            ErrorType.values.map((ErrorType errorType) {
                              return DropdownMenuItem<ErrorType>(
                                value: errorType,
                                child: Text(
                                  errorType.toString().split('.').last,
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Error probability slider
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Error Probability:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${(_errorProbability * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _errorProbability,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged:
                            _mockEnabled
                                ? (value) {
                                  setState(() {
                                    _errorProbability = value;
                                    _updateMockConfiguration();
                                  });
                                }
                                : null,
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Instructions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'How to use:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. Enable mock errors using the switch above\n'
                        '2. Select the type of error you want to simulate\n'
                        '3. Adjust the probability of the error occurring\n'
                        '4. Navigate through the app to see the errors in action\n\n'
                        'Note: This affects all network requests in the app!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMockConfiguration() {
    _apiClient.configureMockError(
      type: _selectedErrorType,
      probability: _errorProbability,
    );
  }
}
