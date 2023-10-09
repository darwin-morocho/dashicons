import 'package:flutter/material.dart';
import 'package:flutter_meedu/consumer.dart';

import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../../../global/widgets/secondary_button.dart';
import '../../../../view/popups/new_package.dart';
import '../../bloc/package_bloc.dart';
import '../dialogs/show_packages.dart';
import 'buttons/download_menu_bar.dart';
import 'buttons/more_options_button.dart';
import 'package_size.dart';

class PackageButtons extends ConsumerWidget {
  const PackageButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(packageProvider).state;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Opacity(
        opacity: state.changesPusblished ? 1 : 0.5,
        child: AbsorbPointer(
          absorbing: !state.changesPusblished,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => showPackages(context),
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  foregroundColor: const MaterialStatePropertyAll(AppColors.dark),
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${ref.watch(packageProvider).state.package.name} ',
                    ),
                    MeeduIcons.expand_more.icon(),
                  ],
                ),
              ),
              SecondaryButton(
                onPressed: () => addOrUpdatePackage(context, package: state.package),
                child: MeeduIcons.page_info.icon(),
              ).paddingOnly(left: 10),
              const PackageSize(),
              const Spacer(),
              const DownloadMenuBar(),
              const VerticalDivider(),
              const MoreOptionsButton(),
            ],
          ),
        ),
      ),
    );
  }
}
