import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/buttons/refresh_button_in_search_bar.dart';
import 'package:taskflow_app/shared/widgets/custom_search_bar.dart';
import 'package:taskflow_app/shared/widgets/error_handler_widget.dart';
import 'package:taskflow_app/shared/widgets/filter_dropdown_filter.dart';
import 'package:taskflow_app/shared/widgets/task/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TaskEntity> _filteredTasks = [];
  List<TaskEntity> _allTasks = [];
  String? _selectedLicensePlate; // Track selected license plate

  @override
  void initState() {
    super.initState();
    // Initialize tasks from the TaskCubit
    final taskState = BlocProvider.of<TaskCubit>(context).state;
    if (taskState is TaskLoaded) {
      _allTasks = taskState.tasks;
      _filteredTasks = _allTasks;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty || query.length < 3) {
      setState(() {
        // Apply only license plate filter if selected
        if (_selectedLicensePlate != null) {
          _filteredTasks =
              _allTasks
                  .where((task) => task.licensePlate == _selectedLicensePlate)
                  .toList();
        } else {
          _filteredTasks = _allTasks;
        }
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    setState(() {
      _filteredTasks =
          _allTasks.where((task) {
            bool matchesSearch =
                task.name.toLowerCase().contains(lowercaseQuery) ||
                task.description.toLowerCase().contains(lowercaseQuery) ||
                task.licensePlate.toLowerCase().contains(lowercaseQuery) ||
                task.id.toLowerCase().contains(lowercaseQuery);

            // Apply license plate filter if selected
            if (_selectedLicensePlate != null) {
              return matchesSearch &&
                  task.licensePlate == _selectedLicensePlate;
            }
            return matchesSearch;
          }).toList();
    });
  }

  // Get unique license plates from all tasks
  List<String> _getUniqueLicensePlates() {
    final Set<String> licensePlates = {};
    for (var task in _allTasks) {
      licensePlates.add(task.licensePlate);
    }
    return licensePlates.toList()..sort();
  }

  void _onLicensePlateSelected(String? licensePlate) {
    setState(() {
      _selectedLicensePlate = licensePlate;

      // Apply search and filter
      if (_searchController.text.isNotEmpty &&
          _searchController.text.length >= 3) {
        _performSearch(_searchController.text);
      } else if (licensePlate != null) {
        _filteredTasks =
            _allTasks
                .where((task) => task.licensePlate == licensePlate)
                .toList();
      } else {
        _filteredTasks = _allTasks;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveConstants.getRelativeWidth(context, 24),
            vertical: ResponsiveConstants.getRelativeHeight(context, 16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      onSearch: _performSearch,
                      hintText: translate('searchTasks'),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveConstants.getRelativeWidth(context, 6),
                  ),
                  RefreshButtonInSearchBar(
                    onTap:
                        () => context.read<TaskCubit>().refreshTasks(
                          context.getUserLocationCode(),
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 16),
              ),
              // Using the new reusable widget
              LicensePlateFilterWidget(
                licensePlates: _getUniqueLicensePlates(),
                selectedLicensePlate: _selectedLicensePlate,
                onChanged: _onLicensePlateSelected,
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 4),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderColor.withAlpha((0.2 * 255).toInt()),
            borderRadius:
                ResponsiveConstants.getRelativeBorderRadius(context, 8),
            border: Border.all(
              color: borderColor.withAlpha((0.5 * 255).toInt()),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: ResponsiveConstants.getRelativeWidth(context, 24),
              right: ResponsiveConstants.getRelativeWidth(context, 24),
              bottom: ResponsiveConstants.getRelativeHeight(context, 16),
            ),
            child: BlocConsumer<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state is TaskLoaded) {
                  setState(() {
                    _allTasks = state.tasks;

                    // Apply existing filters to new data
                    if (_searchController.text.isNotEmpty &&
                        _searchController.text.length >= 3) {
                      _performSearch(_searchController.text);
                    } else if (_selectedLicensePlate != null) {
                      _filteredTasks =
                          _allTasks
                              .where(
                                (task) =>
                                    task.licensePlate == _selectedLicensePlate,
                              )
                              .toList();
                    } else {
                      _filteredTasks = _allTasks;
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskFailure) {
                  return ErrorHandlerWidget(
                    error: state.error,
                    onRetry:
                        state.error.type == ErrorType.network ||
                                state.error.type == ErrorType.server
                            ? () => BlocProvider.of<TaskCubit>(
                              context,
                            ).getAllTasks(context.getUserLocationCode())
                            : null,
                    onBackToHome:
                        state.error.type == ErrorType.notFound
                            ? () => Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst)
                            : null,
                    onLogin:
                        state.error.type == ErrorType.authentication
                            ? () => context.go('/login')
                            : null,
                  );
                } else {
                  return _buildTaskList();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return _filteredTasks.isEmpty
        ? Center(
            child: Text(
              translate('noTasksFound'),
              style: TextStyle(color: mutedForegroundColor),
            ),
          )
        : ListView.builder(
          itemCount: _filteredTasks.length,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveConstants.getRelativeHeight(context, 16),
          ),
          itemBuilder: (context, index) {
            return TaskCard(
              task: _filteredTasks[index],
              onTap: () {
                context.push('/task-overview', extra: _filteredTasks[index]);
              },
            );
          },
        );
  }
}

// Specific implementation for License Plate Filter
class LicensePlateFilterWidget extends StatelessWidget {
  final List<String> licensePlates;
  final String? selectedLicensePlate;
  final ValueChanged<String?> onChanged;
  final double? width;
  final double? height;

  const LicensePlateFilterWidget({
    super.key,
    required this.licensePlates,
    required this.selectedLicensePlate,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FilterDropdownWidget<String>(
      items: licensePlates,
      selectedValue: selectedLicensePlate,
      itemDisplayText: (plate) => plate,
      onChanged: onChanged,
      hintText: translate('licensePlate'),
      allItemsText: translate('allPlates'),
      width: width,
      height: height,
      prefixIcon: Icons.filter_list,
      showClearButton: true,
    );
  }
}
