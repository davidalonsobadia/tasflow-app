import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ErrorHandlerWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final VoidCallback? onContactAdmin;
  final VoidCallback? onBackToHome;
  final VoidCallback? onLogin;

  const ErrorHandlerWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onContactAdmin,
    this.onBackToHome,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveConstants.getRelativeWidth(context, 24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorIcon(),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 16),
            ),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
            ),
            SizedBox(
              height: ResponsiveConstants.getRelativeHeight(context, 24),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    IconData iconData;
    Color iconColor;

    switch (error.type) {
      case ErrorType.network:
        iconData = Icons.signal_wifi_off;
        iconColor = destructiveColor;
        break;
      case ErrorType.authentication:
        iconData = Icons.lock;
        iconColor = priorityMediumColor;
        break;
      case ErrorType.server:
        iconData = Icons.cloud_off;
        iconColor = destructiveColor;
        break;
      case ErrorType.notFound:
        iconData = Icons.search_off;
        iconColor = mutedForegroundColor;
        break;
      case ErrorType.permission:
        iconData = Icons.no_accounts;
        iconColor = priorityMediumColor;
        break;
      case ErrorType.validation:
        iconData = Icons.error_outline;
        iconColor = priorityMediumColor;
        break;
      default:
        iconData = Icons.warning_amber;
        iconColor = destructiveColor;
        break;
    }

    return Icon(iconData, size: 64, color: iconColor);
  }

  Widget _buildActionButtons(BuildContext context) {
    final List<Widget> buttons = [];

    // Add appropriate buttons based on error type
    switch (error.type) {
      case ErrorType.network:
        if (onRetry != null) {
          buttons.add(
            _buildButton(
              context,
              translate('retry'),
              ButtonVariant.primary,
              onRetry!,
            ),
          );
        }
        break;

      case ErrorType.server:
        if (onRetry != null) {
          buttons.add(
            _buildButton(
              context,
              translate('retry'),
              ButtonVariant.primary,
              onRetry!,
            ),
          );
        }
        if (onContactAdmin != null) {
          buttons.add(
            _buildButton(
              context,
              translate('contactAdmin'),
              ButtonVariant.secondary,
              onContactAdmin!,
            ),
          );
        }
        break;

      case ErrorType.authentication:
        if (onLogin != null) {
          buttons.add(
            _buildButton(
              context,
              translate('logIn'),
              ButtonVariant.primary,
              onLogin!,
            ),
          );
        }
        break;

      case ErrorType.notFound:
        if (onBackToHome != null) {
          buttons.add(
            _buildButton(
              context,
              translate('backHome'),
              ButtonVariant.primary,
              onBackToHome!,
            ),
          );
        }
        break;

      case ErrorType.permission:
      case ErrorType.unknown:
        if (onContactAdmin != null) {
          buttons.add(
            _buildButton(
              context,
              translate('contactAdmin'),
              ButtonVariant.primary,
              onContactAdmin!,
            ),
          );
        }
        break;

      case ErrorType.validation:
        // Usually just display the message for validation errors
        break;
    }

    return Wrap(
      spacing: ResponsiveConstants.getRelativeWidth(context, 16),
      runSpacing: ResponsiveConstants.getRelativeHeight(context, 12),
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    ButtonVariant variant,
    VoidCallback onPressed,
  ) {
    return OutlinedAppButton(text: text, onPressed: onPressed, variant: variant);
  }
}
