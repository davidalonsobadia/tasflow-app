import 'dart:io';

import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/features/debug/presentation/pages/mock_error_control_screen.dart';
import 'package:taskflow_app/shared/widgets/navbar/navbar_item.dart';
import 'package:taskflow_app/shared/widgets/navbar/navbar_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_app/shared/services/modal_service.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedBarItem,
    required this.onTap,
  });

  final NavbarItems selectedBarItem;
  final Function(NavbarItems) onTap;

  @override
  Widget build(BuildContext context) {
    // Check if debug tab should be shown
    final bool showDebug = MockErrorControlScreen.shouldShow();
    // Check if user is from a collaborating workshop
    final bool isCollaborating = context.isCollaboratingWorkshop();

    return Container(
      padding: EdgeInsets.only(
        right: ResponsiveConstants.getRelativeWidth(context, 10),
        left: ResponsiveConstants.getRelativeWidth(context, 10),
        top: ResponsiveConstants.getRelativeHeight(context, 16),
        bottom: _getPlatformBottomPadding(context),
      ),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: NavbarItem(
              onTap: () => _handleNavTap(context, NavbarItems.home),
              icon: CupertinoIcons.home,
              label: translate('home'),
              isSelected: selectedBarItem == NavbarItems.home,
            ),
          ),
          if (!isCollaborating)
            Expanded(
              child: NavbarItem(
                onTap: () => _handleNavTap(context, NavbarItems.products),
                icon: Icons.task,
                label: translate('products'),
                isSelected: selectedBarItem == NavbarItems.products,
              ),
            ),
          Expanded(
            child: NavbarItem(
              onTap: () => _handleNavTap(context, NavbarItems.history),
              icon: Icons.history,
              label: translate('history'),
              isSelected: selectedBarItem == NavbarItems.history,
            ),
          ),
          Expanded(
            child: NavbarItem(
              onTap: () => _handleNavTap(context, NavbarItems.settings),
              icon: Icons.settings,
              label: translate('settings'),
              isSelected: selectedBarItem == NavbarItems.settings,
            ),
          ),
          if (showDebug)
            Expanded(
              child: NavbarItem(
                onTap: () => _handleNavTap(context, NavbarItems.debug),
                icon: Icons.bug_report,
                label: 'Debug',
                isSelected: selectedBarItem == NavbarItems.debug,
              ),
            ),
        ],
      ),
    );
  }

  void _handleNavTap(BuildContext context, NavbarItems item) {
    if (item != selectedBarItem) {
      // Close all open modals using our service
      ModalService().closeAllModals();
    }

    // Then call the original onTap handler
    onTap(item);
  }

  double _getPlatformBottomPadding(BuildContext context) {
    if (Platform.isAndroid) {
      return ResponsiveConstants.getRelativeHeight(context, 16);
    }
    return ResponsiveConstants.getRelativeHeight(context, 32);
  }
}
