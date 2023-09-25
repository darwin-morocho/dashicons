import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../../domain/models/svg_icon.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/dialogs/context_menu.dart';
import '../../../../../../global/extensions/sized_box.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';
import '../../bloc/package_bloc.dart';
import 'edit_icon_name.dart';

enum _ContextMenu {
  editName,
  copy,
  download,
  delete,
}

void showIconOptionsContextMenu({
  required BuildContext context,
  required SvgIcon icon,
  required String fontFamily,
}) async {
  final result = await showContextMenu<_ContextMenu>(
    context: context,
    items: [
      PopupMenuItem(
        value: _ContextMenu.copy,
        child: Row(
          children: [
            MeeduIcons.content_copy.icon(),
            const SizedBox(width: 5),
            Text(
              texts.package.icons.copy,
              style: const TextStyle(color: AppColors.dark),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
      PopupMenuItem(
        value: _ContextMenu.download,
        child: Row(
          children: [
            MeeduIcons.download.icon(),
            const SizedBox(width: 5),
            Text(
              texts.package.icons.download,
              style: const TextStyle(color: AppColors.dark),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
      PopupMenuItem(
        value: _ContextMenu.editName,
        child: Row(
          children: [
            MeeduIcons.edit.icon(),
            const SizedBox(width: 5),
            Text(
              texts.package.icons.edit,
              style: const TextStyle(color: AppColors.dark),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
      PopupMenuItem(
        value: _ContextMenu.delete,
        child: Row(
          children: [
            MeeduIcons.delete.icon(),
            const SizedBox(width: 5),
            Text(
              texts.package.icons.remove,
              style: const TextStyle(color: AppColors.dark),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    ],
  );

  if (context.mounted && result != null) {
    switch (result) {
      case _ContextMenu.editName:
        showEditIconNamePopup(
          context,
          icon,
          fontFamily,
        );

      case _ContextMenu.delete:
        packageProvider.read.onRemove(icon);
      case _ContextMenu.copy:
        showSimpleNotification(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MeeduIcons.done_all.icon(),
              10.w,
              Text(
                texts.package.copied,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          position: NotificationPosition.bottom,
          background: AppColors.blue,
        );
        Clipboard.setData(
          ClipboardData(text: icon.name),
        );
      case _ContextMenu.download:
        Repositories.packages.downloadSvgIcon(icon);
    }
  }
}
