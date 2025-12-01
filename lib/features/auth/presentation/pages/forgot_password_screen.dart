import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
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
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: foregroundColor),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is PasswordResetEmailSent) {
                setState(() {
                  _isLoading = false;
                });
                // Navigate to reset password screen with email
                context.push(
                  '/reset-password',
                  extra: {'email': _emailController.text.trim()},
                );
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
                        translate('forgotPassword'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: foregroundColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        translate('enterEmailToResetPassword'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: mutedForegroundColor,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSubmit(),
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
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: mutedForegroundColor,
                          ),
                          labelStyle: TextStyle(color: mutedForegroundColor),
                          hintStyle: TextStyle(color: mutedForegroundColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.radiusXl),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.radiusXl),
                            borderSide: BorderSide(color: borderColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.radiusXl),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: cardColor,
                        ),
                        style: TextStyle(color: foregroundColor),
                      ),
                      SizedBox(height: height * 0.04),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.064,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: primaryForegroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.radiusXl,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: primaryForegroundColor,
                                )
                              : Text(
                                  translate('sendResetLink'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primaryForegroundColor,
                                      ),
                                ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      // Back to login link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            translate('backToLogin'),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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

