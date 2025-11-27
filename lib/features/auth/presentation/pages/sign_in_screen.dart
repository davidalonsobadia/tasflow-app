import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  final List<String> _previousValues = List.generate(4, (index) => '');

  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();

    // Add controller listeners to detect backspace when deleting a digit
    for (var i = 0; i < _controllers.length; i++) {
      final index = i; // Capture index for closure

      _controllers[i].addListener(() {
        final currentValue = _controllers[index].text;

        // If value hasn't changed, skip
        if (_previousValues[index] == currentValue) return;

        // Detect backspace: value became empty (user deleted a digit)
        if (currentValue.isEmpty && _previousValues[index].isNotEmpty) {
          _previousValues[index] = '';

          // Move to previous field if not at first field
          if (index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          return;
        }

        // Handle typing a digit
        if (currentValue.isNotEmpty) {
          // Keep only the last character if multiple were entered
          if (currentValue.length > 1) {
            _controllers[index].text = currentValue[currentValue.length - 1];
            _controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index].text.length),
            );
          }

          _previousValues[index] = _controllers[index].text;

          // Move to next field
          if (index < 3) {
            _focusNodes[index + 1].requestFocus();
          }
        }
      });
    }

    // Add focus listeners to select text when focused
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }

    _isVerifying = false;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                setState(() {
                  _isVerifying = false;
                });
                context.go('/main');
              } else if (state is AuthFailure) {
                setState(() {
                  _isVerifying = false;
                });
                UIUtils.showErrorSnackBar(context, state.errorMessage);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/taskflow_logo.png',
                    width: 213,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    translate('welcome'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    translate('enterVerificationCode'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: onBackgroundColor),
                  ),
                  SizedBox(height: height * 0.03),
                  // Verification code fields
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.035),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: width * 0.16,
                          height: width * 0.16,
                          child: TextField(
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            showCursor: false,
                            onTap: () {
                              _controllers[index].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _controllers[index].text.length,
                              );
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
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
                                borderSide: const BorderSide(
                                  color: greyTextColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: whiteColor,
                            ),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.035),
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.064,
                    child: ElevatedButton(
                      onPressed:
                          _isVerifying
                              ? null
                              : () {
                                setState(() {
                                  _isVerifying = true;
                                });
                                // Get the verification code and process it
                                final code =
                                    _controllers.map((c) => c.text).join();
                                if (code.length == 4) {
                                  // Process verification code
                                  context.read<AuthCubit>().registerDevice(
                                    code,
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        //foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                          _isVerifying
                              ? const CircularProgressIndicator(
                                color: whiteColor,
                              )
                              : Text(
                                translate('verifyCode'),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    translate('theCodeShouldBeGivenByYourAdministrator'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: greyTextColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
