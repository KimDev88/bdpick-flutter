import 'package:flutter/material.dart';

import '../const/const.dart';

class CustomButton {
  // final String buttonText;

  const CustomButton();

  static Widget renderCustomButton(
    String buttonText,
    Size size, {
    Function()? onButtonPressedFunc,
  }) {
    return ElevatedButton(
      onPressed: onButtonPressedFunc,
      style: ButtonStyle(
        backgroundColor: (onButtonPressedFunc == null)
            ? const MaterialStatePropertyAll(Colors.grey)
            : const MaterialStatePropertyAll(BdColors.buttonColor),
        minimumSize: MaterialStatePropertyAll(size),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  static Widget renderSmallButton(
    String buttonText, {
    Size? size,
    Function()? onButtonPressedFunc,
  }) {
    return renderCustomButton(buttonText, size ?? const Size(80, 43),
        onButtonPressedFunc: onButtonPressedFunc);
  }
}
