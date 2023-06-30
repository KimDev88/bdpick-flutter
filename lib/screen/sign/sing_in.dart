import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/common/token_service.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:flutter/material.dart';

import '../../component/common/common_http.dart';
import '../../component/common/sign_service.dart';
import '../../component/custom_button.dart';
import '../../const/const.dart';
import '../../const/enum.dart';
import '../../const/text.dart';
import '../../model/token.dart';
import '../../model/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }

  static void request(dynamic requestData) {
    CommonHttp.request(
      HttpMethod.post,
      ApiUrls.signIn,
      data: requestData,
      successFunction: (data) {
        if (data != null) {
          Map<String, dynamic> resultToken = data[KeyNamesToken.token.name];
          // save tokens
          Token token = Token.fromJson(resultToken);
          TokenService.saveToken(token);

          // save userType
          String userTypeStr = data[KeyNamesUser.userType.name];
          Prefs.setUserType(userTypeStr);
          Prefs.setUserId(requestData[KeyNamesUser.id.name]);

          SignService.navigateToMainsByPrefs();
        }
      },
    );
  }
}

class _SignInState extends State<SignIn> {
  User user = User();

  late Function(String value)? onIdChangedFunc = (value) {
    setState(() {
      user.id = value;
    });
  };
  late Function(String value)? onPasswordChangedFunc = (value) {
    setState(() {
      user.password = value;
    });
  };

  @override
  Widget build(BuildContext context) {
    late Function()? onSignInButtonPressedFunc =
        (user.id != '' && user.password != '')
            ? () {
                SignIn.request(user.toJson());
              }
            : null;

    return BackGroundContainer(
      isUseAppBar: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// 아이디
          CustomInput.renderFullInputField(
            CustomText.labelId,
            onTextChangedFunc: onIdChangedFunc,
          ),

          /// 패스워드
          CustomInput.renderFullInputField(
            CustomText.labelPassword,
            onTextChangedFunc: onPasswordChangedFunc,
            isSecure: true,
            textInputAction: TextInputAction.done,
          ),

          /// 확인 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton.renderSmallButton(
                CustomText.confirm,
                onButtonPressedFunc: onSignInButtonPressedFunc,
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
