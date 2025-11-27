import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class CardListHeader extends StatelessWidget {
  const CardListHeader({
    super.key,
    required this.title,
    required this.icon,
    this.onAdd,
  });

  final String title;
  final IconData icon;
  final Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 4)),
        Icon(
          icon,
          color: primaryColor,
          size: ResponsiveConstants.getRelativeWidth(context, 24),
        ),
        SizedBox(width: ResponsiveConstants.getRelativeWidth(context, 10)),
        Center(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Spacer(),
        if (onAdd != null) ...[
          InkWell(
            onTap: onAdd,
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveConstants.getRelativeWidth(context, 10),
              ),
              child: Icon(
                Icons.add,
                color: primaryColor,
                size: ResponsiveConstants.getRelativeWidth(context, 24),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
