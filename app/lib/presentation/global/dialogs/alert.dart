import 'package:flutter/material.dart';

import '../../generated/translations.g.dart';
import '../extensions/sized_box.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  String? title,
  required String message,
  String? okText,
  dismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (_) => _Content(
      title: title,
      message: message,
      okText: okText,
    ),
  );
}

class _Content extends StatelessWidget {
  const _Content({
    this.title,
    this.okText,
    required this.message,
  });

  final String? title, okText;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          20.h,
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(okText ?? texts.misc.accept),
          ),
        ],
      ),
    );
  }
}
