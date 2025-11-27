import 'dart:io';

import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/shared/widgets/buttons/voice_recording_button.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/base_modal_bottom_sheet.dart';
import 'package:taskflow_app/shared/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AddCommentModal {
  static Future<String?> show(BuildContext context) {
    return BaseModalBottomSheet.show(
      context: context,
      title: translate('addComment'),
      heightFactor: 0.40,
      content: const _AddCommentModalContent(),
      resizeToChildHeight: true, // Enable dynamic resizing
    );
  }
}

class _AddCommentModalContent extends StatefulWidget {
  const _AddCommentModalContent();

  @override
  State<_AddCommentModalContent> createState() =>
      _AddCommentModalContentState();
}

class _AddCommentModalContentState extends State<_AddCommentModalContent> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _hasText = false;
  int _textLines = 1;
  bool _isRecording = false; // Track recording state

  @override
  void initState() {
    super.initState();

    // Add listener to text controller to track changes
    _commentController.addListener(_onTextChanged);

    // Auto-focus the text field after modal is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
  }

  void _onTextChanged() {
    final newText = _commentController.text;
    setState(() {
      _hasText = newText.isNotEmpty;

      // Calculate number of lines (rough estimate)
      _textLines = '\n'.allMatches(newText).length + 1;
      // Clamp the number of lines between 1 and 6
      _textLines = _textLines.clamp(1, 6);
    });
  }

  @override
  void dispose() {
    _commentController.removeListener(_onTextChanged);
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_commentController.text.isNotEmpty) {
      Navigator.pop(context, _commentController.text);
    }
  }

  void _handleVoiceRecognized(String recognizedText) {
    setState(() {
      _commentController.text = recognizedText;
      // This will trigger _onTextChanged through the listener
    });
  }

  void _handleRecordingStateChanged(bool isRecording) {
    setState(() {
      _isRecording = isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate container padding
    final padding = EdgeInsets.only(
      left: ResponsiveConstants.getRelativeWidth(context, 16),
      right: ResponsiveConstants.getRelativeWidth(context, 16),
      top: ResponsiveConstants.getRelativeHeight(context, 16),
      bottom: _getPlatformBottomPadding(context),
    );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: ResponsiveConstants.getRelativeBorderRadius(
                context,
                12,
              ),
              border: Border.all(color: lightGreyColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StyledTextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    hintText: translate('typeCommentHint'),
                    maxLines: 6, // Maximum lines
                    minLines:
                        _textLines, // This changes dynamically with content
                    showBorder: false,
                    onChanged: (value) {
                      // This will trigger _onTextChanged through the listener
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ResponsiveConstants.getRelativeHeight(context, 8),
                    right: ResponsiveConstants.getRelativeHeight(context, 8),
                  ),
                  child: VoiceRecordingButton(
                    showSendButton: _hasText,
                    onTextRecognized: _handleVoiceRecognized,
                    onSendPressed: _handleSend,
                    onRecordingStateChanged: _handleRecordingStateChanged,
                    locale: 'es_ES',
                  ),
                ),
              ],
            ),
          ),
          if (_isRecording)
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveConstants.getRelativeHeight(context, 8),
              ),
              child: Text(
                translate('recordingReleaseToStop'),
                style: TextStyle(color: redTextColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  double _getPlatformBottomPadding(BuildContext context) {
    if (Platform.isAndroid) {
      return ResponsiveConstants.getRelativeHeight(context, 32);
    }
    return ResponsiveConstants.getRelativeHeight(context, 48);
  }
}
