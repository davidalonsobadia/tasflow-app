import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/core/utils/format_utils.dart';
import 'package:taskflow_app/features/products/domain/entities/product_task_with_transfer_entity.dart';
import 'package:taskflow_app/shared/widgets/products/trash_icon.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProductTaskCard extends StatelessWidget {
  const ProductTaskCard({
    super.key,
    required this.taskId,
    required this.productWithTransfer,
    required this.onDelete,
  });

  final String taskId;
  final ProductTaskWithTransferEntity productWithTransfer;
  final Function(String systemId) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConstants.getRelativeHeight(context, 10),
        horizontal: ResponsiveConstants.getRelativeWidth(context, 10),
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  productWithTransfer.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
              ),
              TrashIcon(onDelete: () => _showDeleteConfirmationDialog(context)),
            ],
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 5)),
          Text(
            productWithTransfer.product.id,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(
                  'quantityAvailable',
                  args: {
                    'quantity': FormatUtils.formatAmount(
                      productWithTransfer.product.quantity,
                    ),
                  },
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: mutedForegroundColor),
              ),
              if (productWithTransfer.transferStatus !=
                  TransferStatus.notApplicable) ...[
                _buildTransferStatusBadge(
                  context,
                  productWithTransfer.transferStatus,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: translate('deleteProduct'),
          message: translate('areYouSureYouWantToDeleteThisProduct'),
          confirmText: translate('delete'),
        );
      },
    );

    if (confirm == true) {
      onDelete(productWithTransfer.product.systemId!);
    }
  }

  Widget _buildTransferStatusBadge(
    BuildContext context,
    TransferStatus status,
  ) {
    Color badgeColor;
    Color textColor;
    String translatedStatus;

    switch (status) {
      case TransferStatus.pending:
        badgeColor = priorityMediumColor.withAlpha(25);
        textColor = priorityMediumColor;
        translatedStatus = translate('pending');
        break;
      case TransferStatus.partial:
        badgeColor = priorityLowColor.withAlpha(25);
        textColor = priorityLowColor;
        translatedStatus = translate('partial');
        break;
      case TransferStatus.completed:
        badgeColor = chartColors[1].withAlpha(25);
        textColor = chartColors[1];
        translatedStatus = translate('completed');
        break;
      case TransferStatus.unknown:
        badgeColor = secondaryColor;
        textColor = mutedForegroundColor;
        translatedStatus = translate('unknown');
        break;
      case TransferStatus.notApplicable:
        badgeColor = Colors.transparent;
        textColor = mutedForegroundColor;
        translatedStatus = '';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConstants.getRelativeWidth(context, 12),
        vertical: ResponsiveConstants.getRelativeHeight(context, 4),
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Text(
        translatedStatus,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}
