import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (newText.length >= 11) {
      newText =
          '(${newText.substring(0, 2)}) ${newText.substring(2, 3)} ${newText.substring(3, 7)}-${newText.substring(7, 11)}';
    } else if (newText.length >= 6) {
      newText =
          '(${newText.substring(0, 2)}) ${newText.substring(2, 3)} ${newText.substring(3, newText.length)}';
    } else if (newText.length >= 2) {
      newText = '(${newText.substring(0, 2)}) ${newText.substring(2)}';
    } else if (newText.isEmpty) {
      newText = '';
    }

    int selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  int _calculateCursorPosition(String newText) {
    int lastDigitIndex = newText.length - 1;
    while (lastDigitIndex >= 0 &&
        !RegExp(r'\d').hasMatch(newText[lastDigitIndex])) {
      lastDigitIndex--;
    }
    return lastDigitIndex + 1;
  }
}
