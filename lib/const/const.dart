import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/shop.dart';
import '../model/user.dart';

class BdColors {
  // static const Color buttonColor = Colors.pink;
  static const Color fontColor = Colors.deepPurple;
  static const Color buttonColor = Colors.deepPurple;
  static const Color secondColor = Colors.pinkAccent;
  static const Color backgroundColor = Colors.purple;
  static const Color hintFontColor = Colors.grey;
  static const Color errorTextColor = Color(0xFFF48FB1);
  static const Color hintColor = Colors.grey;
}

class TextStyles {
  /// TextStyle(fontSize: 15.0, color: BdColors.hintColor)
  static const TextStyle hintLabelSmall =
      TextStyle(fontSize: 15.0, color: BdColors.hintColor);
  static const TextStyle imageWidgetLabel =
      TextStyle(fontSize: 13.0, color: BdColors.buttonColor);
  static const TextStyle inputTextLabel = TextStyle(
      fontSize: 15.0, color: BdColors.fontColor, fontWeight: FontWeight.w600);
}

class RouteKeys {
  static const String main = 'main';
  static const String signUp = 'sign_up';
  static const String signupComplete = 'signup_complete';
  static const String signIn = 'sign_in';
  static const String adMain = 'ad_main';
  static const String shopMain = 'shop_main';
  static const String shopRegist = 'shop_regist';
  static const String shopRegistSecond = 'shop_regist_second';
  static const String createAd = 'create_ad';
}

class ApiUrls {
  static const String apiUrlLocal = 'http://192.168.0.4:8080';
  static const String apiUrlDev = 'http://152.69.231.150:8080';
  // static const String apiUrl = apiUrlLocal;
  static const String apiUrl = apiUrlDev;

  static const String _prefixApiUrl = '/api';

  /// sign
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String signIn = '$_prefixApiUrl/sign/in';
  static const String signUp = '$_prefixApiUrl/sign/up';
  static const String signCheckId = '$_prefixApiUrl/sign/check';
  static const String signSendmail = '$_prefixApiUrl/sign/send-mail';
  static const String signVerifyEmail = '$_prefixApiUrl/sign/verify-mail';

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /// shop
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String shops = '$_prefixApiUrl/shops';
  static const String shopThis = '$_prefixApiUrl/shops/this';
  static const String shopCheckRegister = '$_prefixApiUrl/shops/check-register';
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

class Prefs {
  static SharedPreferences? prefs;

  static String? getUserId() {
    if (prefs != null && prefs!.containsKey(KeyNamesUser.userId.name)) {
      return prefs!.getString(KeyNamesUser.userId.name);
    }
    return null;
  }

  static setUserId(String userId) {
    prefs!.setString(KeyNamesUser.userId.name, userId);
  }

  static setUserType(String userTypeStr) {
    prefs!.setString(KeyNamesUser.userType.name, userTypeStr);
  }

  static clear() {
    prefs!.clear();
  }

  static Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void clearShopSignPrefs() {
    if (prefs != null) {
      prefs!.remove(KeyNamesShop.addressFullName.name);
      prefs!.remove(KeyNamesShop.addressName.name);
      prefs!.remove(KeyNamesShop.name.name);
      prefs!.remove(KeyNamesShop.ownerName.name);
      prefs!.remove(KeyNamesShop.registNumber.name);
      prefs!.remove(KeyNamesShop.type.name);
      prefs!.remove(KeyNamesShop.tel.name);
    }
  }

  static void setPrefs(Map<String, dynamic> data) {
    prefs!.setInt(KeyNamesShop.id.name, data[KeyNamesShop.id.name]);
    prefs!.setString(KeyNamesShop.name.name, data[KeyNamesShop.name.name]);
    prefs!.setString(
        KeyNamesShop.ownerName.name, data[KeyNamesShop.ownerName.name]);
    prefs!.setString(
        KeyNamesShop.registNumber.name, data[KeyNamesShop.registNumber.name]);
    prefs!.setString(KeyNamesShop.type.name, data[KeyNamesShop.type.name]);
    prefs!.setString(KeyNamesShop.tel.name, data[KeyNamesShop.tel.name]);
    prefs!.setString(
        KeyNamesShop.addressName.name, data[KeyNamesShop.addressName.name]);
    // FIXME 임시
    prefs!.setString(KeyNamesShop.addressFullName.name, '임시 주소');
  }
}
