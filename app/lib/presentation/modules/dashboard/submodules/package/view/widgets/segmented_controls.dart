import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:hooks_meedu/hooks_meedu.dart';
import 'package:hooks_meedu/rx_hook.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/icons.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../../../global/widgets/fetching_button.dart';
import '../../../../../../global/widgets/secondary_button.dart';
import '../../bloc/package_bloc.dart';

class PackageSegmentedControls extends StatelessWidget {
  const PackageSegmentedControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer(
          builder: (_, ref, __) {
            final state = ref.watch(packageProvider).state;
            final tabIndex = state.tabIndex;

            final options = [
              (
                MeeduIcons.apps,
                '${texts.package.packageIcons} (${state.package.icons.length})',
              ),
              (
                MeeduIcons.code,
                texts.package.dartCode,
              ),
            ];

            return ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Row(
                children: List.generate(
                  options.length,
                  (i) {
                    final option = options[i];
                    final color = tabIndex == i ? Colors.white : AppColors.dark;
                    return Material(
                      color: tabIndex == i ? AppColors.darkLight : Colors.white,
                      child: InkWell(
                        onTap: () => packageProvider.read.onTabIndexChanged(i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              option.$1.icon(
                                color: color,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                option.$2,
                                style: TextStyle(
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const Spacer(),
        HookConsumer(
          builder: (context, ref, __) {
            final fetching = useRx(false);
            final bloc = ref.watch(packageProvider);
            final changesPusblished = bloc.state.changesPusblished;
            return Row(
              children: [
                Tooltip(
                  message: bloc.state.reorder
                      ? texts.package.reorder.disable
                      : texts.package.reorder.enable,
                  child: SecondaryButton(
                    onPressed: bloc.toogleReorder,
                    child: MeeduIcons.move_up.icon(
                      color: bloc.state.reorder ? AppColors.blue : AppColors.dark,
                    ),
                  ),
                ).paddingOnly(right: 10),
                if (bloc.state.package.icons.any((e) => !e.selected))
                  SecondaryButton.text(
                    texts.package.selectAll,
                    onPressed: bloc.onSelectAll,
                  ).paddingOnly(right: 10),
                if (!changesPusblished)
                  ElevatedButton.icon(
                    onPressed: bloc.revertChanges,
                    icon: MeeduIcons.rollback.icon(),
                    label: Text(texts.package.undo),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(AppColors.dark),
                      elevation: MaterialStatePropertyAll(0),
                    ),
                  ).paddingOnly(right: 10),
                AbsorbPointer(
                  absorbing: changesPusblished,
                  child: RxBuilder(
                    (_) => FetchingButton(
                      fetching: fetching.value,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          changesPusblished ? Colors.white : AppColors.dark,
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                          changesPusblished ? AppColors.dark.withOpacity(0.3) : Colors.white,
                        ),
                        elevation: const MaterialStatePropertyAll(0),
                      ),
                      onPressed: () async {
                        fetching.value = true;
                        final published = await bloc.publishChanges();
                        fetching.value = false;
                        if (!published && context.mounted) {
                          toast(
                            texts.misc.failures.unhandled,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      },
                      text: texts.package.pusblish,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
