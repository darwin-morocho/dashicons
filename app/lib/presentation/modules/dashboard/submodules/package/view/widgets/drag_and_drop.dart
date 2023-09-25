import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_meedu/hooks_meedu.dart';

import '../../../../../../generated/assets.gen.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../../global/extensions/widgets.dart';
import '../../../../../../global/theme/colors.dart';
import '../../bloc/package_bloc.dart';
import '../utils/svg_parser.dart';
import '../utils/upload_svg_files.dart';

class DragAndDrop extends HookConsumerWidget {
  const DragAndDrop({super.key});

  @override
  Widget build(BuildContext context, BuilderRef ref) {
    final dragging = useState(false);
    final dropZoneController = useRef<DropzoneViewController?>(null);
    final state = ref.watch(packageProvider).state;

    if (state.reorder) {
      return Center(
        child: Text(
          texts.package.reorder.toast,
          style: context.textTheme.titleLarge,
        ),
      );
    }

    return Opacity(
      opacity: state.changesPusblished ? 1 : 0.3,
      child: AbsorbPointer(
        absorbing: !state.changesPusblished,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () => uploadSvgFiles(context),
            child: Stack(
              children: [
                if (kIsWeb && state.changesPusblished)
                  DropzoneView(
                    operation: DragOperation.copy,
                    cursor: CursorType.grab,
                    onCreated: (DropzoneViewController ctrl) => dropZoneController.value = ctrl,
                    onHover: () => dragging.value = true,
                    onLeave: () => dragging.value = false,
                    onDrop: (value) {
                      dragging.value = false;
                      // print(value);
                    },
                    onDropMultiple: (elements) async {
                      dragging.value = false;
                      if (elements == null) {
                        return;
                      }
                      final controller = dropZoneController.value!;

                      final items = <SvgData>[];

                      for (final htmlFile in elements) {
                        final fileName = await controller.getFilename(htmlFile);
                        if (!fileName.endsWith('.svg')) {
                          continue;
                        }
                        final bytes = await controller.getFileData(htmlFile);
                        items.add(
                          SvgData(
                            fileName: fileName,
                            svgAsString: utf8.decode(bytes),
                          ),
                        );
                      }
                      if (context.mounted && items.isNotEmpty) {
                        await uploadSvgsData(
                          context,
                          items,
                        );
                      }
                    },
                  ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  strokeWidth: 3,
                  dashPattern: const [10, 10],
                  color: dragging.value ? AppColors.blue : AppColors.dark,
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.package.icons.isEmpty) ...[
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: SvgPicture.asset(
                            Assets.package.icons,
                          ),
                        ).fullWidth,
                        const SizedBox(height: 20),
                      ],
                      Text(
                        kIsWeb ? texts.package.dragAndDropHere : texts.package.clicHere,
                        style: context.textTheme.titleLarge,
                      ).center.paddingAll(30),
                    ],
                  ),
                ).fullWidth,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
