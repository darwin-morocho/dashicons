import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/translations.g.dart';
import '../extensions/sized_box.dart';
import '../extensions/widgets.dart';
import '../theme/colors.dart';

Future<bool> showConfirmContextMenu({
  required BuildContext context,
  required String message,
  String? cancelText,
  String? confirmText,
  Color borderColor = Colors.white,
  BoxConstraints? constraints,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final button = context.findRenderObject() as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    const Offset(50, -25) & overlay.size,
  );

  final completer = Completer<bool>();

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              entry.remove();
              completer.complete(false);
            },
            child: const Material(
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: position.bottom,
          right: position.right,
          width: 300,
          child: Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message),
                10.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xfff9f9f9),
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                          AppColors.dark,
                        ),
                      ),
                      onPressed: () {
                        entry.remove();
                        completer.complete(false);
                      },
                      child: Text(cancelText ?? texts.misc.cancel),
                    ),
                    15.w,
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          AppColors.red,
                        ),
                      ),
                      onPressed: () {
                        entry.remove();
                        completer.complete(true);
                      },
                      child: Text(confirmText ?? texts.misc.accept),
                    ),
                  ],
                ),
              ],
            ).paddingAll(15),
          ),
        ),
      ],
    ),
  );

  Overlay.of(context).insert(entry);

  return completer.future;
}
