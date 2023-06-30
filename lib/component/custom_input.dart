import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import 'custom_button.dart';

class CustomInput {
  static BuildContext context = NavigationService.navigatorKey.currentContext!;
  static Size size = MediaQuery.of(context).size;
  static Color inputFilledColor = Colors.white.withAlpha(100);

  /// 가로 전체를 차지하는 인풋 필드를 그린다.
  static Widget renderFullInputField(
    String labelText, {
    String? helperText,
    String? hintText,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    String? errorText,
    FocusNode? focusNode,
    Color? filledColor,
    bool isSecure = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    Function(String value)? onTextChangedFunc,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          renderLabel(labelText: labelText),
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          renderInputFieldWithPadding(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            obscureText: isSecure,
            onTextChangedFunc: onTextChangedFunc,
            focusNode: focusNode,
            filledColor: filledColor,
            keyboardType: keyboardType,
            controller: controller,
            textStyle: textStyle,
            textInputAction: textInputAction,
          ),
        ],
      ),
    );
  }

  /// input field와 버튼을 함께 그린다.
  static Widget renderInputFieldWithButton(
    String labelText,
    String buttonText, {
    TextStyle? textStyle,
    String? hintText,
    TextStyle? hintStyle,
    String? errorText,
    FocusNode? focusNode,
    Color? filledColor,
    TextInputType? keyboardType,
    TextEditingController? controller,
    Function(String value)? onTextChangedFunc,
    Function()? onButtonPressedFunc,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          renderLabel(labelText: labelText),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                //   width: size.width * 0.8,
                child: renderInputField(
                  hintText: hintText,
                  errorText: errorText,
                  onTextChangedFunc: onTextChangedFunc,
                  filledColor: filledColor,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  controller: controller,
                  hintStyle: hintStyle,
                  textStyle: textStyle,
                ),
              ),
              CustomButton.renderSmallButton(
                buttonText,
                onButtonPressedFunc: onButtonPressedFunc,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget renderInputFieldWithPadding(
      {String? hintText,
      TextStyle? hintStyle,
      TextStyle? textStyle,
      String? helperText,
      String? errorText,
      bool? obscureText,
      FocusNode? focusNode,
      Color? filledColor,
      Widget? suffixIcon,
      TextInputType? keyboardType,
      TextEditingController? controller,
      TextInputAction? textInputAction,
      Function(String value)? onTextChangedFunc}) {
    filledColor ??= inputFilledColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: renderInputField(
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        obscureText: obscureText,
        focusNode: focusNode,
        filledColor: filledColor,
        suffixIcon: suffixIcon,
        keyboardType: keyboardType,
        controller: controller,
        textStyle: textStyle,
        onTextChangedFunc: onTextChangedFunc,
        textInputAction: textInputAction,
      ),
    );
  }

  /// input field를 그린다
  static Widget renderInputField(
      {String? hintText,
      TextStyle? hintStyle,
      String? helperText,
      String? errorText,
      bool? obscureText,
      FocusNode? focusNode,
      Color? filledColor,
      Widget? suffixIcon,
      TextInputType? keyboardType,
      TextStyle? textStyle,
      TextEditingController? controller,
      TextInputAction? textInputAction,
      bool? readOnly,
      Function()? onTapFunction,
      Function(String value)? onTextChangedFunc}) {
    filledColor ??= inputFilledColor;
    return TextField(
      cursorColor: BdColors.buttonColor,
      obscureText: obscureText ?? false,
      onChanged: onTextChangedFunc,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      controller: controller,
      // onSubmitted: (value) => context.nextEditableTextFocus(),
      focusNode: focusNode,
      onTap: onTapFunction,
      readOnly: readOnly ?? false,
      style: textStyle ??
          const TextStyle(
              fontSize: 20.0,
              color: BdColors.fontColor,
              fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: BdColors.backgroundColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: BdColors.buttonColor),
        ),

        filled: true,
        fillColor: filledColor,
        isDense: true,

        /// hint
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(
                fontWeight: FontWeight.w100, color: BdColors.hintFontColor),
        helperText: helperText,

        /// error
        errorText: errorText,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: BdColors.secondColor),
        ),
        errorStyle: const TextStyle(color: BdColors.secondColor),
        // suffixIcon: suffixIcon,
        // suffixIcon: suffixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  /// [labelText]의 텍스트로 input의 label을 그린다.
  static Widget renderLabel({String? labelText, Text? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.centerLeft,
      child: text ??
          Text(
            labelText!,
            style: Theme.of(context).textTheme.labelSmall,
          ),
    );
  }

  /// radio button을 그린다.
  static Widget renderRadioButton<T>(
      T value, T groupValue, String labelText, Function(T? value) onChanged) {
    return Expanded(
      flex: 5,
      // width: size.width / 2,
      child: RadioListTile<T>(
        fillColor: const MaterialStatePropertyAll(BdColors.buttonColor),
        activeColor: BdColors.buttonColor,
        title: Text(labelText),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
