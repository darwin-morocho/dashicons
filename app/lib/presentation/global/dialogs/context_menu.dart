import 'dart:async';

import 'package:flutter/material.dart';


Future<T?> showContextMenu<T>({
  required BuildContext context,
  required List<PopupMenuItem<T>> items,
  Color borderColor = Colors.white,
  BoxConstraints? constraints,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final button = context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    const Offset(0, -3) & overlay.size,
  );

  return showMenu<T>(
    context: context,
    position: position,
    surfaceTintColor: Colors.white,
    constraints: constraints ?? const BoxConstraints(maxWidth: 380),
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        width: 2,
        color: borderColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    items: items,
    elevation: 10,
  );
}

