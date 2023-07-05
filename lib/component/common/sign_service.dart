import 'package:flutter/material.dart';

import '../../const/const.dart';
import '../../const/enum.dart';
import '../../model/user.dart';
import 'navigation_service.dart';

class SignService {
  static void navigateToMainsByPrefs() {
    String userTypeStr = Prefs.prefs!.getString(KeyNamesUser.userType.name)!;
    UserType userType = UserTypeBuilder.create(userTypeStr);
    // Navigator.pushNamedAndRemoveUntil(
    Navigator.pushNamed(
      // Navigator.pushNamed(
      NavigationService.navigatorKey.currentContext!,
      UserType.N == userType
          ? RouteKeys.adMain
          : (UserType.O == userType ? RouteKeys.shopMain : RouteKeys.main),
      // (route) => false,
    );
  }
}
