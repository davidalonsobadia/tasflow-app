import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is Authenticated) {
                setState(() {
                  _isLoading = false;
                });
                // Fade out before navigating
                final navigator = GoRouter.of(context);
                await _fadeController.reverse();
                if (mounted) {
                  navigator.go('/main');
                }
              } else if (state is AuthFailure) {
                setState(() {
                  _isLoading = false;
                });
                UIUtils.showErrorSnackBar(context, state.errorMessage);
              }
            },
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.1),
                        Image.asset(
                          'assets/images/taskflow_logo.png',
                          width: 213,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          translate('welcome'),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          translate('signInToContinue'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: onBackgroundColor),
                        ),
                        SizedBox(height: height * 0.04),
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('emailRequired');
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return translate('invalidEmailFormat');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: translate('email'),
                            hintText: translate('enterYourEmail'),
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                              borderSide: BorderSide(
                                color: onPrimaryColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: whiteColor,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('passwordRequired');
                            }
                            if (value.length < 6) {
                              return translate('passwordTooShort');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: translate('password'),
                            hintText: translate('enterYourPassword'),
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                              borderSide: BorderSide(
                                color: onPrimaryColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: whiteColor,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push('/forgot-password');
                            },
                            child: Text(
                              translate('forgotPassword'),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.064,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    ResponsiveConstants.getRelativeBorderRadius(
                                      context,
                                      12,
                                    ),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: whiteColor,
                                    )
                                    : Text(
                                      translate('logIn'),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              translate('dontHaveAccount'),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: greyTextColor),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/register');
                              },
                              child: Text(
                                translate('signUp'),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
