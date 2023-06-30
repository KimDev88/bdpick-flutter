import 'package:bd_pick/component/common/common_http.dart';
import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/common/token_service.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../component/background_container.dart';
import '../../component/custom_button.dart';
import '../../const/const.dart';
import '../../model/token.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final Size rowButtonSize = const Size(200, 60);
  final Size columnButtonSize = const Size(150, 50);
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  onSignupButtonPressedFunc() => {
        Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!, RouteKeys.signUp)
      };

  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
      isUseAppBar: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton.renderCustomButton('무료 이용하기', rowButtonSize),
          CustomButton.renderCustomButton(
            '회원으로 이용하기',
            rowButtonSize,
            onButtonPressedFunc: () => Navigator.pushNamed(
                context, RouteKeys.signupComplete),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton.renderCustomButton(
                  '회원가입',
                  columnButtonSize,
                  onButtonPressedFunc: onSignupButtonPressedFunc,
                ),
                CustomButton.renderCustomButton(
                  '아이디/비밀번호 찾기',
                  columnButtonSize,
                  onButtonPressedFunc: () {
                    CommonHttp.request(HttpMethod.post, ApiUrls.signIn,
                        data: {'id': 'su240'}, successFunction: (data) async {
                      Token token = Token.fromJson(data);
                      TokenService.saveToken(token);
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
