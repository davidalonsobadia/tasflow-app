import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConnectivityCheckScreen extends StatefulWidget {
  final Widget child;

  const ConnectivityCheckScreen({super.key, required this.child});

  @override
  State<ConnectivityCheckScreen> createState() =>
      _ConnectivityCheckScreenState();
}

class _ConnectivityCheckScreenState extends State<ConnectivityCheckScreen> {
  final Connectivity _connectivity = Connectivity();
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    setState(() {
      _hasConnection = results.any((r) => r != ConnectivityResult.none);
    });
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((results) {
      setState(() {
        _hasConnection = results.any((r) => r != ConnectivityResult.none);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _hasConnection ? widget.child : _buildNoConnectionScreen(context);
  }

  Widget _buildNoConnectionScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveConstants.getRelativeWidth(context, 24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: ResponsiveConstants.getRelativeHeight(context, 80),
                  color: primaryColor,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 24),
                ),
                Text(
                  translate('noInternetConnection'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 16),
                ),
                Text(
                  translate('noInternetConnectionPleaseCheckYourConnection'),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                ),
                SizedBox(
                  height: ResponsiveConstants.getRelativeHeight(context, 24),
                ),
                ElevatedButton(
                  onPressed: _checkInitialConnectivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: onPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          ResponsiveConstants.getRelativeBorderRadius(context, 12),
                    ),
                  ),
                  child: Text(translate('retry')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
