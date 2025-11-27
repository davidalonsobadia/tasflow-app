import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  const NavbarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.iconSize,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final double? iconSize;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final color = isSelected ? primaryColor : unselectedButtonNavbarColor;

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: iconSize ?? width * 0.07),
          SizedBox(height: height * 0.002),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
