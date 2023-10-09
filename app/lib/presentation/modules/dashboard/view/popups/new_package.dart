import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:flutter_meedu/screen_utils.dart';
import 'package:hooks_meedu/rx_hook.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../domain/models/package.dart';
import '../../../../generated/translations.g.dart';
import '../../../../global/extensions/widgets.dart';
import '../../../../global/theme/colors.dart';
import '../../../../global/utils/input_formatters.dart';
import '../../../../global/widgets/secondary_button.dart';
import '../../bloc/dashboard_bloc.dart';

Future<Package?> addOrUpdatePackage(BuildContext context, {Package? package}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => NewPackage(
      package: package,
    ),
  );
}

class NewPackage extends HookWidget {
  const NewPackage({
    super.key,
    this.package,
  });
  final Package? package;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: package?.name ?? '');
    final fontPackageController = useTextEditingController(text: package?.fontPackage ?? '');
    final fontFamilyController = useTextEditingController(text: package?.fontFamily ?? '');
    final state = useState(
      package ??
          Package(
            id: '',
            name: '',
            lastId: 1,
            fontFamily: '',
            fontPackage: '',
            icons: [],
          ),
    );

    final fetching = useRx(false);

    Future<void> create() async {
      fetching.value = true;

      final createdPackage = await dashboardProvider.read().createPackage(
        state.value,
      );

      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }

      if (createdPackage != null) {
        Navigator.pop(context, createdPackage);
      } else {
        fetching.value = false;
        toast(texts.misc.failures.unhandled);
      }
    }

    Future<void> update() async {
      fetching.value = true;

      final updated = await dashboardProvider.read().updatePackage(
        state.value,
      );

      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }

      if (updated) {
        Navigator.pop(context);
      } else {
        fetching.value = false;
        toast(texts.misc.failures.unhandled);
      }
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: state.value.id.isEmpty
          ? Text(
              texts.dashboard.newPackage.title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _Label(
            label: texts.dashboard.newPackage.name.label,
            info: texts.dashboard.newPackage.name.info,
          ),
          TextField(
            controller: nameController,
            onChanged: (text) => state.value = state.value.copyWith(
              name: text.trim(),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
            ],
          ),
          const SizedBox(height: 20),
          _Label(
            label: texts.dashboard.newPackage.fontFamily.label,
            info: texts.dashboard.newPackage.fontFamily.info,
          ),
          TextField(
            controller: fontFamilyController,
            onChanged: (text) => state.value = state.value.copyWith(
              fontFamily: text,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              FirstLetterUppercaseTextInputFormatter(),
            ],
          ),
          const SizedBox(height: 20),
          _Label(
            label: texts.dashboard.newPackage.fontPackage.label,
            info: texts.dashboard.newPackage.fontPackage.info,
          ),
          TextField(
            controller: fontPackageController,
            onChanged: (text) => state.value = state.value.copyWith(
              fontPackage: text,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-z_]')),
              FirstLetterTextInputFormatter(),
            ],
          ),
          const SizedBox(height: 30),
          RxBuilder(
            (_) {
              if (fetching.value) {
                return const Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Row(
                children: [
                  SecondaryButton.text(
                    texts.misc.cancel,
                    onPressed: () => Navigator.pop(context),
                    foregroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ).expanded,
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: state.value.name.isNotEmpty && state.value.fontFamily.isNotEmpty
                        ? state.value.id.isNotEmpty
                            ? update
                            : create
                        : null,
                    child: Text(
                      state.value.id.isEmpty
                          ? texts.dashboard.newPackage.create
                          : texts.misc.update,
                    ),
                  ).expanded,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.label,
    required this.info,
  });
  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
        ),
        Tooltip(
          message: info,
          preferBelow: false,
          textStyle: context.textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.info_rounded),
        ),
      ],
    ).padding(
      const EdgeInsets.only(bottom: 5),
    );
  }
}
