import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:taskflow_app/shared/widgets/buttons/voice_recording_button.dart';
import 'package:taskflow_app/shared/widgets/dialogs/complete_collaboration_result.dart';
import 'package:taskflow_app/shared/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CompleteCollaborationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? cancelText;
  final String? confirmText;
  final String? hintText;
  final ButtonVariant cancelVariant;
  final ButtonVariant confirmVariant;
  final double? width; // Optional width parameter
  final double maxWidthPercentage; // Percentage of screen width

  const CompleteCollaborationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText,
    this.confirmText,
    this.hintText,
    this.cancelVariant = ButtonVariant.secondary,
    this.confirmVariant = ButtonVariant.primary,
    this.width, // No default, will use screen percentage if null
    this.maxWidthPercentage = 0.95, // Default to 85% of screen width
  });

  @override
  State<CompleteCollaborationDialog> createState() =>
      _CompleteCollaborationDialogState();
}

class _CompleteCollaborationDialogState
    extends State<CompleteCollaborationDialog> {
  final TextEditingController _commentController = TextEditingController();
  bool _isTaskFinished = false;
  bool _isRecording = false;
  bool _shouldShowMicButton = true;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onCommentChanged);
  }

  void _onCommentChanged() {
    setState(() {
      // Update mic button visibility based on text content and recording state
      _shouldShowMicButton =
          _commentController.text.trim().isEmpty || _isRecording;
    });
  }

  @override
  void dispose() {
    _commentController.removeListener(
      _onCommentChanged,
    ); // Good practice to remove listener
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cancelText = widget.cancelText ?? translate('cancel');
    final confirmText = widget.confirmText ?? translate('confirm');
    final hintText = widget.hintText ?? translate('typeCommentHint');

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Container(
        width:
            widget.width ??
            MediaQuery.of(context).size.width * widget.maxWidthPercentage,
        constraints: BoxConstraints(maxWidth: 600, minWidth: 280),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 16),
              ),
              Text(
                widget.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 16),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      ResponsiveConstants.getRelativeBorderRadius(context, 8),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StyledTextField(
                        controller: _commentController,
                        maxLines: 4,
                        hintText: hintText,
                        showBorder: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        ResponsiveConstants.getRelativeWidth(context, 8),
                      ),
                      child: Visibility(
                        visible: _shouldShowMicButton,
                        child: VoiceRecordingButton(
                          showSendButton: false,
                          onTextRecognized: (recognizedText) {
                            setState(() {
                              _commentController.text = recognizedText;
                              // The _onCommentChanged listener will automatically update _shouldShowMicButton
                            });
                          },
                          onRecordingStateChanged: (isRecording) {
                            setState(() {
                              _isRecording = isRecording;
                              // Update mic button visibility considering both recording state and text content
                              _shouldShowMicButton =
                                  _commentController.text.trim().isEmpty ||
                                  _isRecording;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 36),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 0),
                    child: SizedBox(
                      width: ResponsiveConstants.getRelativeWidth(context, 24),
                      height: ResponsiveConstants.getRelativeWidth(context, 24),
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        value: _isTaskFinished,
                        onChanged: (value) {
                          setState(() {
                            _isTaskFinished = value ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 8),
                  ),
                  Expanded(
                    child: Text(
                      translate('markTaskAsFinished'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 12),
              ),
              Row(
                children: [
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 4),
                  ),
                  Expanded(
                    child: Text(
                      translate(
                        'ifUncheckedTheCollaborationWillBeSavedButTaskWillRemainInProgress',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedAppButton(
                    width: ResponsiveConstants.getRelativeWidth(context, 120),
                    text: cancelText,
                    onPressed: () => Navigator.pop(context),
                    variant: widget.cancelVariant,
                  ),
                  OutlinedAppButton(
                    width: ResponsiveConstants.getRelativeWidth(context, 120),
                    text: confirmText,
                    onPressed:
                        () => Navigator.pop(
                          context,
                          CompleteCollaborationResult(
                            comment: _commentController.text,
                            isTaskFinished: _isTaskFinished,
                          ),
                        ),
                    variant: widget.confirmVariant,
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
