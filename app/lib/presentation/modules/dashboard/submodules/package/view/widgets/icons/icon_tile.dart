import 'package:flutter/material.dart';

import '../../../../../../../../domain/models/svg_icon.dart';
import '../../../../../../../global/theme/colors.dart';

class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.fontFamily,
    required this.onTap,
    required this.onRightClick,
    required this.reorder,
  });
  final SvgIcon icon;
  final String fontFamily;
  final VoidCallback onTap;
  final bool reorder;
  final void Function(BuildContext) onRightClick;

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 3,
            color: icon.selected ? AppColors.dark : Colors.white,
          ),
        ),
        child: Builder(
          builder: (context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onSecondaryTapDown: (details) {
                onRightClick(context);
              },
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: Text(
                    icon.charCode,
                    style: TextStyle(
                      color: AppColors.dark.withOpacity(icon.selected ? 1 : 0.5),
                      fontFamily: fontFamily,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (reorder) {
      return child;
    }

    return Tooltip(
      message: icon.name,
      decoration: BoxDecoration(
        color: AppColors.dark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
