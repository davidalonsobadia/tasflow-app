import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/ui_utils.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/buttons/outlined_app_button.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/base_modal_bottom_sheet.dart';
import 'package:taskflow_app/shared/widgets/vehicle_client_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class ModalBottomVehicleInfo {
  final Function(TaskEntity)? onTaskSelected;

  const ModalBottomVehicleInfo({this.onTaskSelected});

  void show(BuildContext context) {
    BaseModalBottomSheet.show(
      context: context,
      title: translate('searchTask'),
      heightFactor: 0.70,
      content: _VehicleInfoContent(onTaskSelected: onTaskSelected),
      resizeToChildHeight: true,
    );
  }
}

class _VehicleInfoContent extends StatefulWidget {
  final Function(TaskEntity)? onTaskSelected;

  const _VehicleInfoContent({this.onTaskSelected});

  @override
  State<_VehicleInfoContent> createState() => _VehicleInfoContentState();
}

class _VehicleInfoContentState extends State<_VehicleInfoContent> {
  bool _showManualEntry = false;
  late final TextEditingController _controller;
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showManualEntry
        ? _buildManualEntryContent()
        : _buildVehicleInfoContent();
  }

  Widget _buildVehicleInfoContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
        vertical: ResponsiveConstants.getRelativeHeight(context, 16),
      ),
      child: VehicleClientInfoContent(
        errorMessage: _errorMessage,
        onScanQrTap: () {
          // Keep the bottom sheet open
          context.push('/qr-scanner').then((result) {
            if (result != null && result is Map<String, dynamic>) {
              if (result.containsKey('qrData')) {
                final taskId = result['qrData'];
                _findAndHandleTask(taskId);
              }
            }
          });
        },
        onManualEntryTap: () {
          setState(() {
            _showManualEntry = true;
            _errorMessage = null;
          });
        },
      ),
    );
  }

  Widget _buildManualEntryContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
        vertical: ResponsiveConstants.getRelativeHeight(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  ResponsiveConstants.getRelativeBorderRadius(context, 12),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(color: foregroundColor),
              decoration: InputDecoration(
                hintText: translate('enterTaskId'),
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
                prefixText: 'PS-',
                prefixStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: mutedForegroundColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConstants.getRelativeWidth(context, 16),
                  vertical: ResponsiveConstants.getRelativeHeight(context, 16),
                ),
              ),
              keyboardType: TextInputType.text,
              autofocus: true,
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 8)),
            Text(
              _errorMessage!,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ],
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedAppButton(
                text: translate('back'),
                onPressed: () {
                  setState(() {
                    _showManualEntry = false;
                    _errorMessage = null;
                    _controller.clear();
                  });
                },
                variant: ButtonVariant.secondary,
              ),
              OutlinedAppButton(
                text: translate('confirm'),
                onPressed:
                    _isProcessing
                        ? null
                        : () {
                          if (_controller.text.isNotEmpty) {
                            final taskId = 'PS-${_controller.text}';
                            _findAndHandleTask(taskId);
                          }
                        },
                variant: ButtonVariant.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _findAndHandleTask(String taskId) {
    print('Finding task with ID: $taskId');
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final taskState = context.read<TaskCubit>().state;
    if (taskState is TaskLoaded) {
      // Check if task exists
      print('Tasks loaded: ${taskState.tasks.length}');
      final taskExists = taskState.tasks.any((task) => task.id == taskId);

      if (!taskExists) {
        setState(() {
          _isProcessing = false;
          _errorMessage = translate('taskNotFound', args: {'taskId': taskId});
        });
        return;
      }

      // Find the matching task
      final matchingTask = taskState.tasks.firstWhere(
        (task) => task.id == taskId,
      );

      // Found a matching task, navigate to task description
      if (widget.onTaskSelected != null) {
        print('Navigating to task description');
        UIUtils.showSuccessSnackBar(
          context,
          translate('taskFound', args: {'taskId': taskId}),
        );
        context.pop(); // Close the bottom sheet
        widget.onTaskSelected!(matchingTask);
      }
    } else {
      UIUtils.showErrorSnackBar(context, translate('tasksNotLoaded'));
      context.pop();
    }
  }
}
