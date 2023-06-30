import 'package:bd_pick/screen/shop/create_ad.dart';
import 'package:bd_pick/screen/shop/shop_regist.dart';
import 'package:bd_pick/screen/shop/shop_regist_second.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';
import '../../screen/ad_main.dart';
import '../../screen/sign/sign_main.dart';
import '../../screen/shop/shop_main.dart';
import '../../screen/sign/sign_up.dart';
import '../../screen/sign/sign_in_start.dart';
import '../../screen/sign/sing_in.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      /// 메인
      RouteKeys.main: (context) => const MainScreen(),

      /// 회원 가입
      RouteKeys.signUp: (context) => const SignUp(),

      /// 회원 가입 후 인트로
      RouteKeys.signupComplete: (context) => const SignUpComplete(),

      /// 회원 로그인
      RouteKeys.signIn: (context) => const SignIn(),

      /// 광고 메인
      RouteKeys.adMain: (context) => const AdMain(),

      /// 가게 관련 라우터

      /// 가게 메인
      RouteKeys.shopMain: (context) => const ShopMain(),

      /// 가게 등록
      RouteKeys.shopRegist: (context) => const ShopRegist(),

      /// 가게 등록 2번쨰
      RouteKeys.shopRegistSecond: (context) => const ShopRegistSecond(),

      /// 홍보 등록
      RouteKeys.createAd: (context) => const CreateAd(restorationId: 'createAd'),
    };
  }
}
