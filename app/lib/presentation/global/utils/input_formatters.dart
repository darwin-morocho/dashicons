import 'package:flutter/services.dart';

class FirstLetterUppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      return TextEditingValue(
        text: newValue.text.substring(0, 1).toUpperCase() + newValue.text.substring(1),
        selection: newValue.selection,
      );
    }

    return newValue;
  }
}

class FirstLetterTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      var firstChar = newValue.text[0];
      if (!RegExp(r'[a-z]').hasMatch(firstChar)) {
        var newString = newValue.text.replaceRange(
          0,
          1,
          '',
        );
        return TextEditingValue(
          text: newString,
          selection: TextSelection.collapsed(offset: newString.length),
        );
      }
    }
    return newValue;
  }
}
