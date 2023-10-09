import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_meedu/hooks_meedu.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../../domain/typedefs.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/build_context.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/theme/colors.dart';
import '../../../../../../global/widgets/secondary_button.dart';
import '../../bloc/package_bloc.dart';
import '../utils/svg_parser.dart';
import '../utils/upload_svg_files.dart';

enum _From { icons, fluttericon }

Future<void> importConfigFile(BuildContext context) async {
  try {
    final result = await showDialog<(int, _From)>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ImportConfigFile(),
    );
    // ignore: use_build_context_synchronously
    if (result == null || !context.mounted) {
      return;
    }

    final pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (pickerResult == null || pickerResult.files.isEmpty) {
      return;
    }

    final bloc = packageProvider.read();

    final override = bloc.state.package.icons.isEmpty || result.$1 == 1;
    final file = pickerResult.files.first;
    final json = jsonDecode(
      utf8.decode(
        kIsWeb ? file.bytes! : await XFile(file.path!).readAsBytes(),
      ),
    );

    if (json is! Json) {
      toast('Invalid config file');
    }

    var items = <SvgData>[];

    switch (result.$2) {
      case _From.icons:
        items = (json['icons'] as List)
            .where((e) {
              final name = e['name'];
              if (name is! String || name.isEmpty) {
                return false;
              }

              final path = e['path'];

              if (path is! String || path.isEmpty) {
                return false;
              }

              return true;
            })
            .map(
              (e) => SvgData(
                fileName: e['name'],
                svgAsString:
                    '<svg><path d="${Repositories.packages.read().decodeCompressedSvgPath(e['path'])}"/></svg>',
              ),
            )
            .toList();
        break;
      case _From.fluttericon:
        items = (json['glyphs'] as List)
            .where((e) {
              final name = e['css'];
              if (name is! String || name.isEmpty) {
                return false;
              }

              final svg = e['svg'];
              if (svg is! Map) {
                return false;
              }

              final path = svg['path'];
              if (path is! String || path.isEmpty) {
                return false;
              }

              return true;
            })
            .map(
              (e) => SvgData(
                fileName: e['css'],
                svgAsString: '<svg><path d="${e['svg']['path']}"/></svg>',
              ),
            )
            .toList();
        break;
    }

    if (items.isEmpty) {
      return;
    }

    final parserResult = svgParser(items);
    final errors = parserResult.$1;
    final svgs = parserResult.$2;

    // ignore: use_build_context_synchronously
    if (!context.mounted) {
      return;
    }

    if (svgs.isNotEmpty) {
      if (bloc.state.package.icons.isEmpty) {
        final updated = await bloc.onAddIcons(svgs);
        if (!updated) {
          toast(texts.misc.failures.unhandled);
        }
      } else {
        bloc.onImport(svgs, override);
      }
    }
    if (errors.isNotEmpty && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => ParseSvgErrorDialog(errors: errors),
      );
    }
  } catch (e) {
    toast(texts.misc.failures.unhandled);
  }
}

class ImportConfigFile extends HookConsumerWidget {
  const ImportConfigFile({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final option = useState(0);
    final currentIcons = ref.watch(packageProvider).state.package.icons;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        texts.package.import.label,
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentIcons.isNotEmpty) ...[
            RadioListTile(
              value: 0,
              tileColor: Colors.white,
              groupValue: option.value,
              title: Text(texts.package.import.mergeIcons),
              onChanged: (value) {
                option.value = value!;
              },
            ),
            RadioListTile(
              value: 1,
              tileColor: Colors.white,
              groupValue: option.value,
              title: Text(texts.package.import.overrideIcons),
              onChanged: (value) {
                option.value = value!;
              },
            ),
            const SizedBox(height: 20),
          ],
          SecondaryButton.text(
            texts.package.import.cloudicons,
            onPressed: () => Navigator.pop(
              context,
              (option.value, _From.icons),
            ),
          ).fullWidth,
          const SizedBox(height: 20),
          SecondaryButton.text(
            texts.package.import.fluttericon,
            onPressed: () => Navigator.pop(
              context,
              (option.value, _From.fluttericon),
            ),
          ).fullWidth,
          const SizedBox(height: 50),
          SecondaryButton.text(
            texts.misc.cancel,
            onPressed: () => Navigator.pop(context),
            textStyle: const TextStyle(color: AppColors.red),
          ).fullWidth,
        ],
      ),
    );
  }
}
