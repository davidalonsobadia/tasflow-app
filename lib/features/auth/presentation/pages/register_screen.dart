import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthCubit>().register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
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
              if (state is RegistrationSuccess) {
                setState(() {
                  _isLoading = false;
                });
                UIUtils.showSuccessSnackBar(
                  context,
                  translate('registrationSuccessful'),
                );
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
                        translate('createAccount'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        translate('fillInYourDetails'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: greyTextColor,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      // Name field
                      _buildTextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        nextFocusNode: _emailFocusNode,
                        label: translate('name'),
                        hint: translate('enterYourName'),
                        icon: Icons.person_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('nameRequired');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      // Email field
                      _buildTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        nextFocusNode: _passwordFocusNode,
                        label: translate('email'),
                        hint: translate('enterYourEmail'),
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
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
                      ),
                      SizedBox(height: height * 0.02),
                      // Password field
                      _buildPasswordField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        nextFocusNode: _confirmPasswordFocusNode,
                        label: translate('password'),
                        hint: translate('enterYourPassword'),
                        obscureText: _obscurePassword,
                        onToggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
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
                      ),
                      SizedBox(height: height * 0.02),
                      // Confirm password field
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        label: translate('confirmPassword'),
                        hint: translate('confirmYourPassword'),
                        obscureText: _obscureConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleRegister(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('confirmPasswordRequired');
                          }
                          if (value != _passwordController.text) {
                            return translate('passwordsDoNotMatch');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.04),
                      // Register button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.064,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
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
                                  translate('signUp'),
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
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translate('alreadyHaveAccount'),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: greyTextColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              translate('logIn'),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          nextFocusNode.requestFocus();
        }
      },
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
          borderSide: BorderSide(color: onPrimaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: whiteColor,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted ??
          (_) {
            if (nextFocusNode != null) {
              nextFocusNode.requestFocus();
            }
          },
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
          borderSide: BorderSide(color: onPrimaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: whiteColor,
      ),
    );
  }
}

