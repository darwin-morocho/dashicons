import 'package:flutter/material.dart';

import '../../../../../../../generated/translations.g.dart';
import '../../../../../../../global/dialogs/context_menu.dart';
import '../../../../../../../global/extensions/build_context.dart';
import '../../../../../../../global/icons.dart';
import '../../../../../../../global/theme/colors.dart';
import '../../../bloc/package_bloc.dart';
import '../../utils/download.dart';

class DownloadMenuBar extends StatelessWidget {
  const DownloadMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showMenu(context),
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        elevation: const MaterialStatePropertyAll(0),
        foregroundColor: const MaterialStatePropertyAll(AppColors.dark),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      child: Row(
        children: [
          MeeduIcons.cloud_download.icon(
            color: AppColors.dark,
          ),
          const SizedBox(width: 10),
          Text(
            texts.package.download,
            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.dark),
          ),
          MeeduIcons.expand_more.icon(
            color: AppColors.dark,
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) async {
    final result = await showContextMenu(
      context: context,
      items: [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              MeeduIcons.download.icon(),
              const SizedBox(width: 10),
              Text(
                '${packageProvider.read().state.package.fontFamily}.ttf',
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              MeeduIcons.download.icon(),
              const SizedBox(width: 10),
              const Text(
                'backup.json',
              ),
            ],
          ),
        )
      ],
    );

    if (result == null) {
      return;
    }

    // ignore: use_build_context_synchronously
    if (!context.mounted) {
      return;
    }

    switch (result) {
      case 0:
        downloadFontIcons(context);
        break;
      case 1:
        downloadBackup(context);
        break;
    }
  }
}
