import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../const/const.dart';

class CommonDialog {
  static void showProgress({String? text}) {
    /// loading dialog config
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..backgroundColor = Colors.transparent
      // ..indicatorColor = Colors.deepPurple
      ..indicatorColor = BdColors.buttonColor
      ..textColor = Colors.lightBlue
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 100.0
      ..radius = 10.0
      ..userInteractions = false
      ..boxShadow = [];

    EasyLoading.show(status: text);
  }

  static void closeProgress() {
    EasyLoading.dismiss();
  }

  static void show(
      {String? titleText, String? contextText, String closeText = '닫기'}) {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: titleText != null
              ? Text(
                  titleText,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 18.0),
                )
              : null,
          content: contextText != null
              ? SingleChildScrollView(child: Text(contextText))
              : null,
          actions: <Widget>[
            Center(
              child: CustomButton.renderCustomButton(
                closeText,
                Size(50, 30),
                onButtonPressedFunc: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
