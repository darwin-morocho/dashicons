import 'package:flutter/material.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/dialogs/context_menu.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../bloc/dashboard_bloc.dart';
import '../../../../view/popups/new_package.dart';
import '../../bloc/package_bloc.dart';

Future<void> showPackages(BuildContext context) async {
  final packageBloc = packageProvider.read();
  await dashboardProvider.read().state.mapOrNull(
    loaded: (state) async {
      final result = await showContextMenu(
        context: context,
        items: [
          PopupMenuItem(
            value: 'new',
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: context.size!.width,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.darkLight,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    MeeduIcons.add.icon(),
                    const SizedBox(width: 10),
                    Text(texts.dashboard.createNewPackage),
                  ],
                ).padding(
                  const EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
              ),
            ),
          ),
          ...state.packages.where((e) => e.id != packageBloc.state.package.id).map(
                (e) => PopupMenuItem(
                  value: e.id,
                  child: Row(
                    children: [
                      MeeduIcons.double_arrow.icon(),
                      const SizedBox(width: 10),
                      Text(e.name),
                    ],
                  ),
                ),
              ),
        ],
      );

      // ignore: use_build_context_synchronously
      if (result == null || !context.mounted) {
        return;
      }

      if (result == 'new') {
        final createdPackage = await addOrUpdatePackage(context);
        if (createdPackage != null) {
          packageBloc.onPackageChanged(createdPackage);
        }
      } else {
        dashboardProvider.read().state.mapOrNull(
          loaded: (state) {
            packageBloc.onPackageChanged(
              state.packages.firstWhere((element) => element.id == result),
            );
          },
        );
      }
    },
  );
}
