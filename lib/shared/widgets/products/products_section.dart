import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_state.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_card_item.dart';
import 'package:taskflow_app/shared/widgets/modal_bottom_sheet/modal_bottom_products.dart';
import 'package:taskflow_app/shared/widgets/card_list_header.dart';
import 'package:taskflow_app/shared/widgets/products/empty_item_placeholder.dart';
import 'package:taskflow_app/shared/widgets/products/product_task_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({
    super.key,
    required this.taskId,
    required this.onDelete,
    this.modalBottomHeightPercentage,
    required this.locationCode,
  });
  final double? modalBottomHeightPercentage;
  final String taskId;
  final String locationCode;
  final Function(String systemId) onDelete;

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  @override
  void initState() {
    super.initState();
    // Load products when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductTaskCubit>().getProductTasksByTaskId(
        widget.taskId,
        widget.locationCode,
      );
    });
  }

  void _addNewProduct(BuildContext context) {
    return ModalBottomProducts(
      heightPercentage: widget.modalBottomHeightPercentage,
      locationCode: widget.locationCode,
      onProductWithQuantitySelected: (product, quantity) {
        // Get the task to access its licensePlate
        final taskState = context.read<TaskCubit>().state;
        String licensePlate = '';

        if (taskState is TaskLoaded) {
          TaskEntity? task = taskState.tasks.cast<TaskEntity?>().firstWhere(
            (task) => task?.id == widget.taskId,
            orElse: () => null,
          );
          if (task != null) {
            licensePlate = task.licensePlate;
          }
        }

        context.read<ProductTaskCubit>().addProductTask(
          widget.taskId,
          product.id,
          product.type,
          quantity,
          widget.locationCode,
          licensePlate,
        );
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is from a collaborating workshop
    final bool isCollaborating = context.isCollaboratingWorkshop();

    // If collaborating workshop, don't show the products section at all
    if (isCollaborating) {
      return const SizedBox.shrink();
    }

    return CardContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardListHeader(
            title: translate('products'),
            icon: CupertinoIcons.archivebox_fill,
            onAdd: () => _addNewProduct(context),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
          BlocBuilder<ProductTaskCubit, ProductTaskState>(
            builder: (context, state) {
              if (state is ProductTaskLoading) {
                return LoadingIndicatorInCardItem();
              } else if (state is ProductTaskFailure) {
                return Center(child: Text(state.error.message));
              } else if (state is ProductTaskLoaded) {
                final products = state.productTasksWithTransfer;

                if (products.isEmpty) {
                  return EmptyItemPlaceholder(
                    iconItem: CupertinoIcons.cube_box_fill,
                    noItemsAdded: translate('noProductsAddedYet'),
                    addItem: translate('addProduct'),
                    onAdd: () => _addNewProduct(context),
                  );
                }

                return Column(
                  children: [
                    for (int i = 0; i < products.length; i++) ...[
                      ProductTaskCard(
                        taskId: widget.taskId,
                        productWithTransfer: products[i],
                        onDelete: widget.onDelete,
                      ),
                      if (i < products.length - 1)
                        SizedBox(
                          height: ResponsiveConstants.getRelativeHeight(
                            context,
                            20,
                          ),
                        ),
                    ],
                  ],
                );
              }
              return LoadingIndicatorInCardItem();
            },
          ),
        ],
      ),
    );
  }
}
