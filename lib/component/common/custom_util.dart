import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:flutter/material.dart';

class CustomUtil {
  static BuildContext? context = NavigationService.navigatorKey.currentContext;

  static Size getContextSize() {
    return MediaQuery.sizeOf(context!);
  }
}
