import 'package:flutter/material.dart';

import '../../../../../../../generated/translations.g.dart';
import '../../../../../../../global/dialogs/context_menu.dart';
import '../../../../../../../global/icons.dart';
import '../../../../../../../global/widgets/secondary_button.dart';
import '../../../bloc/package_bloc.dart';
import '../../dialogs/import.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onPressed: () => _showMenu(context),
      child: Row(
        children: [
          Text(texts.package.buttons.dropdown.moreOptions),
          const SizedBox(width: 5),
          MeeduIcons.expand_more.icon(),
        ],
      ),
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final bloc = packageProvider.read;
    final result = await showContextMenu(
      context: context,
      items: [
        PopupMenuItem(
          value: MoreOptions.clearSelection,
          child: Row(
            children: [
              MoreOptions.clearSelection.iconData.icon(),
              const SizedBox(width: 5),
              Text(texts.package.buttons.dropdown.clear),
            ],
          ),
        ),
        PopupMenuItem(
          value: MoreOptions.removeAll,
          child: Row(
            children: [
              MoreOptions.removeAll.iconData.icon(),
              const SizedBox(width: 5),
              Text(texts.package.buttons.dropdown.removeAll),
            ],
          ),
        ),
        if (bloc.state.changesPusblished)
          PopupMenuItem(
            value: MoreOptions.import,
            child: Row(
              children: [
                MoreOptions.import.iconData.icon(),
                const SizedBox(width: 5),
                Text(texts.package.import.label),
              ],
            ),
          ),
      ],
    );
    // ignore: use_build_context_synchronously
    if (result == null || !context.mounted) {
      return;
    }

    switch (result) {
      case MoreOptions.clearSelection:
        bloc.onClearSelection();
        break;
      case MoreOptions.removeAll:
        bloc.onRemoveAll();
        break;
      case MoreOptions.import:
        importConfigFile(context);
        break;
    }
  }
}

enum MoreOptions {
  clearSelection(MeeduIcons.clear_all),
  removeAll(MeeduIcons.delete_sweep),
  import(MeeduIcons.upload_file),
  ;

  const MoreOptions(this.iconData);

  final IconData iconData;
}
