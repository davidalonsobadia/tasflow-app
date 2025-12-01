import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  bool _animationComplete = false;
  bool _authCheckComplete = false;
  AuthState? _latestAuthState;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for a 4 second sequence
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Background color transition animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Logo fade in animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text fade animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Set up listener for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _animationComplete = true;
          });
          _attemptNavigation();
        }
      }
    });

    _controller.forward();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Start the auth check process
      final authCubit = context.read<AuthCubit>();

      // Set up a timeout for auth check
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && !_authCheckComplete) {
          setState(() {
            _authCheckComplete = true;
            _latestAuthState = AuthFailure(
              AppError(
                message: translate('authenticationTimedOut'),
                type: ErrorType.authentication,
              ),
            );
          });
          _attemptNavigation();
        }
      });

      // Start auth check and update state when complete
      authCubit
          .checkAuthStatus()
          .then((_) {
            if (mounted) {
              setState(() {
                _authCheckComplete = true;
                _latestAuthState = authCubit.state;
              });
              _attemptNavigation();
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _authCheckComplete = true;
                _latestAuthState = AuthFailure(ErrorHandler.handle(error));
              });
              _attemptNavigation();
            }
          });
    } catch (e) {
      if (mounted) {
        setState(() {
          _authCheckComplete = true;
          _latestAuthState = AuthFailure(ErrorHandler.handle(e));
        });
        _attemptNavigation();
      }
    }
  }

  void _attemptNavigation() {
    // Only navigate when both conditions are met
    if (_animationComplete && _authCheckComplete && mounted) {
      _handleNavigation(_latestAuthState!);
    }
  }

  void _handleNavigation(AuthState state) {
    // Avoid duplicate navigation
    if (!mounted) return;

    if (state is Authenticated) {
      context.go('/main');
    } else if (state is Unauthenticated) {
      context.go('/login');
    } else if (state is AuthFailure) {
      UIUtils.showErrorSnackBar(context, state.errorMessage);
      // Fallback navigation on failure
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Transition from primary color to dark background
                  Color.lerp(
                        primaryColor,
                        backgroundColor,
                        _backgroundAnimation.value,
                      ) ??
                      primaryColor,
                  Color.lerp(
                        primaryColor.withAlpha((0.8 * 255).toInt()),
                        backgroundColor,
                        _backgroundAnimation.value,
                      ) ??
                      primaryColor.withAlpha((0.8 * 255).toInt()),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Single logo with fade animation
                  Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Image.asset(
                      'assets/images/taskflow_logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Text that fades in and stays visible, changing color with background
                  Opacity(
                    opacity: _textFadeAnimation.value,
                    child: Text(
                      translate('urbanEquipments'),
                      style: TextStyle(
                        color: Color.lerp(
                          foregroundColor,
                          primaryColor,
                          _backgroundAnimation.value,
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),

                  // Optional loading indicator that appears after animation completes
                  if (_animationComplete && !_authCheckComplete)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
