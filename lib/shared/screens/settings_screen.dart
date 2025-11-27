import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isUnbinding = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          setState(() {
            _isUnbinding = false;
          });
          // Clear timer state when user logs out
          context.go('/login');
        } else if (state is AuthFailure) {
          setState(() {
            _isUnbinding = false;
          });
          UIUtils.showErrorSnackBar(context, state.errorMessage);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              ResponsiveConstants.getRelativeHeight(context, 16),
            ),
            color: whiteColor,
            child: Text(
              translate('settings'),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: onPrimaryColor, width: 1)),
            ),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is! Authenticated) return SizedBox.shrink();
              final name = state.user.name;
              final initials =
                  name
                      .trim()
                      .split(' ')
                      .where((p) => p.isNotEmpty)
                      .map((p) => p[0])
                      .take(2)
                      .join()
                      .toUpperCase();
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
                  vertical: ResponsiveConstants.getRelativeHeight(context, 16),
                ),
                child: CardContainer(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: onPrimaryColor,
                        child: Text(
                          initials.isEmpty ? 'U' : initials,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveConstants.getRelativeWidth(
                          context,
                          12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap:
                      _isUnbinding
                          ? null
                          : () {
                            setState(() {
                              _isUnbinding = true;
                            });
                            context.read<AuthCubit>().unbindDevice();
                          },
                  child: CardContainer(
                    padding: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveConstants.getRelativeWidth(
                          context,
                          16,
                        ),
                        vertical: ResponsiveConstants.getRelativeHeight(
                          context,
                          16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: redTextColor),
                          SizedBox(
                            width: ResponsiveConstants.getRelativeWidth(
                              context,
                              16,
                            ),
                          ),
                          Text(
                            translate('unbindDevice'),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: redTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
