import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _tokenFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tokenFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthCubit>().resetPassword(
        widget.email,
        _passwordController.text,
        _tokenController.text.trim(),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: onBackgroundColor),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is PasswordResetSuccess) {
                setState(() {
                  _isLoading = false;
                });
                UIUtils.showSuccessSnackBar(
                  context,
                  translate('passwordResetSuccessful'),
                );
                // Navigate back to login
                context.go('/login');
              } else if (state is AuthFailure) {
                setState(() {
                  _isLoading = false;
                });
                UIUtils.showErrorSnackBar(context, state.errorMessage);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                        translate('resetPassword'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        translate('enterResetCodeAndNewPassword'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: greyTextColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      // Show email
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceLightBlue,
                          borderRadius: ResponsiveConstants.getRelativeBorderRadius(
                            context,
                            8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined, color: onSurfaceLightBlue),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Text(
                                widget.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: onSurfaceLightBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      // Token field (for mock, we accept MOCK_TOKEN)
                      TextFormField(
                        controller: _tokenController,
                        focusNode: _tokenFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('resetCodeRequired');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: translate('resetCode'),
                          hintText: translate('enterResetCode'),
                          helperText: translate('mockTokenHint'),
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
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
                            borderSide: BorderSide(color: onPrimaryColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                ResponsiveConstants.getRelativeBorderRadius(
                                  context,
                                  12,
                                ),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: whiteColor,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      // New password field
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _confirmPasswordFocusNode.requestFocus();
                        },
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
                          labelText: translate('newPassword'),
                          hintText: translate('enterNewPassword'),
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
                            borderSide: BorderSide(color: onPrimaryColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                ResponsiveConstants.getRelativeBorderRadius(
                                  context,
                                  12,
                                ),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: whiteColor,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      // Confirm password field
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSubmit(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('confirmPasswordRequired');
                          }
                          if (value != _passwordController.text) {
                            return translate('passwordsDoNotMatch');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: translate('confirmPassword'),
                          hintText: translate('confirmYourPassword'),
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
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
                            borderSide: BorderSide(color: onPrimaryColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                ResponsiveConstants.getRelativeBorderRadius(
                                  context,
                                  12,
                                ),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: whiteColor,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.064,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  ResponsiveConstants.getRelativeBorderRadius(
                                    context,
                                    12,
                                  ),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: whiteColor)
                              : Text(
                                  translate('resetPassword'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                    ],
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

