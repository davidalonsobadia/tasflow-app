import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';

class VoiceRecordingButton extends StatefulWidget {
  final Function(String)? onTextRecognized;
  final bool showSendButton;
  final VoidCallback? onSendPressed;
  final String? locale; // Optional locale, defaults to 'es_ES'
  final Function(bool)?
  onRecordingStateChanged; // Callback for recording state changes

  const VoiceRecordingButton({
    super.key,
    this.onTextRecognized,
    this.showSendButton = false,
    this.onSendPressed,
    this.locale = 'es_ES',
    this.onRecordingStateChanged,
  });

  @override
  State<VoiceRecordingButton> createState() => _VoiceRecordingButtonState();
}

class _VoiceRecordingButtonState extends State<VoiceRecordingButton>
    with SingleTickerProviderStateMixin {
  // Speech to text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Animation controller for recording pulse effect
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initSpeech();

    // Initialize animation controller for recording pulse effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
          // Notify parent about recording state change
          if (widget.onRecordingStateChanged != null) {
            widget.onRecordingStateChanged!(false);
          }
        }
      },
    );
  }

  // Start listening to speech
  void _startListening() async {
    if (!_isListening) {
      HapticFeedback.mediumImpact();
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        // Notify parent about recording state change
        if (widget.onRecordingStateChanged != null) {
          widget.onRecordingStateChanged!(true);
        }
        await _speech.listen(
          onResult: (result) {
            if (widget.onTextRecognized != null) {
              widget.onTextRecognized!(result.recognizedWords);
            }
          },
          localeId: widget.locale ?? 'es_ES',
        );
      } else {
        UIUtils.showErrorSnackBar(
          context,
          translate('speechRecognitionNotAvailable'),
        );
      }
    }
  }

  // Stop listening to speech
  void _stopListening() {
    if (_isListening) {
      HapticFeedback.lightImpact();
      _speech.stop();
      setState(() {
        _isListening = false;
      });
      // Notify parent about recording state change
      if (widget.onRecordingStateChanged != null) {
        widget.onRecordingStateChanged!(false);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.cancel(); // Make sure to cancel any active speech recognition
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.showSendButton ? widget.onSendPressed : null,
        onLongPress: widget.showSendButton ? null : _startListening,
        onLongPressUp: _stopListening,
        child:
            _isListening
                ? AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveConstants.getRelativeWidth(context, 8),
                        ),
                        decoration: BoxDecoration(
                          color: destructiveColor.withAlpha(
                            (0.3 * 255).toInt(),
                          ), // Red background when recording
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic,
                          color: destructiveColor, // Red mic when recording
                          size: ResponsiveConstants.getRelativeWidth(
                            context,
                            28,
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Container(
                  padding: EdgeInsets.all(
                    ResponsiveConstants.getRelativeWidth(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.showSendButton ? Icons.send : Icons.mic,
                    color: primaryColor,
                    size: ResponsiveConstants.getRelativeWidth(context, 28),
                  ),
                ),
      ),
    );
  }
}
