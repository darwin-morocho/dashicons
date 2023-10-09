// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/theme/colors.dart';
import '../../bloc/package_bloc.dart';
import 'svg_parser.dart';

Future<void> uploadSvgFiles(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: ['svg'],
  );

  if (result == null || result.files.isEmpty) {
    return;
  }

  final items = <SvgData>[];
  for (final file in result.files) {
    final fileName = file.name;
    final svgAsString = utf8.decode(
      kIsWeb ? file.bytes! : await XFile(file.path!).readAsBytes(),
    );
    items.add(
      SvgData(fileName: fileName, svgAsString: svgAsString),
    );
  }

  return uploadSvgsData(context, items);
}

Future<void> uploadSvgsData(BuildContext context, List<SvgData> items) async {
  final parserResult = svgParser(items);
  final errors = parserResult.$1;
  final svgs = parserResult.$2;

  if (svgs.isNotEmpty) {
    final updated = await packageProvider.read().onAddIcons(svgs);
    if (!updated) {
      toast(texts.misc.failures.unhandled);
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
}

class ParseSvgErrorDialog extends StatelessWidget {
  const ParseSvgErrorDialog({
    super.key,
    required this.errors,
  });
  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.package.failures.upload.message,
          ),
          const SizedBox(height: 10),
          ...errors.map(
            (e) => ListTile(
              leading: const Icon(
                Icons.circle,
                color: AppColors.dark,
                size: 5,
              ),
              minLeadingWidth: 20,
              title: Text(e),
              dense: true,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ok'),
        ),
      ],
    );
  }
}
