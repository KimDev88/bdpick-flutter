import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/common/common_dialog.dart';
import 'package:bd_pick/component/common/common_http.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:bd_pick/screen/sign/sing_in.dart';
import 'package:flutter/material.dart';

import '../../component/custom_button.dart';
import '../../const/const.dart';
import '../../const/message.dart';
import '../../const/text.dart';
import '../../model/user.dart';

class _IsVerify {
  static bool id = false;
  static bool email = false;
  static bool code = false;
  static bool sendEmail = false;
}

class _FocusNodes {
  static FocusNode password = FocusNode();
  static FocusNode code = FocusNode();
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  /// 유저 타입
  UserType userType = UserType.N;

  /// 버튼 색상
  User user = User();

  /// 패스워드 에러 메시지
  String? passwordErrorText;

  /// 패스워드 힌트 메시지
  String? passwordHelperText = CustomMessage.helperPassword;

  /// 패스워드 확인 에러 메시지
  String? passwordConfirmErrorText;

  /// 패스워드 확인 텍스트
  String? passwordConfirmText;

  /// 이메일 에러 메시지
  String? emailErrorText;

  /// 검증코드
  String verifyCode = '';

  /// 아이디 변경
  // late Function(String)? onIdChangedFunc = (value) {
  late Function(String)? onIdChangedFunc = (value) {
    setState(() {
      user.id = value;
      _IsVerify.id = false;
    });
  };

  /// 패스워드 변경
  late Function(String)? onPasswordChangedFunc = (value) {
    user.password = value;

    /// 값이 아예 없을 경우
    if (value == '') {
      passwordHelperText = CustomMessage.helperPassword;
      passwordErrorText = null;
    } else if (!value.contains(RegExp(
        r'^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@!%*#?&])[A-Za-z0-9$@!%*#?&]{8,}'))) {
      passwordErrorText = CustomMessage.helperPassword;
    } else {
      passwordHelperText = null;
      passwordErrorText = null;
    }
    verifyPassword();
  };

  /// 패스워드 확인 변경
  late Function(String) onPasswordConfirmChangedFunc = (value) {
    passwordConfirmText = value;
    verifyPassword();
  };

  /// 이메일 변경
  late Function(String) onEmailChangedFunc = (value) {
    setState(() {
      user.email = value;
      _IsVerify.sendEmail = false;
      _IsVerify.code = false;

      /// 값이 아예 없을 경우
      if (value == '') {
        emailErrorText = null;
        _IsVerify.email = false;
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        emailErrorText = CustomMessage.errorEmail;
        _IsVerify.email = false;
      } else {
        emailErrorText = null;
        _IsVerify.email = true;
      }
    });
  };

  /// 인증코드 변경
  late Function(String) onCodeChangedFunc = (value) {
    setState(() {
      verifyCode = value;
      _IsVerify.code = false;
    });
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 아이디 버튼 pressed
    late Function()? onIdButtonPressedFunc = !_IsVerify.id && user.id != ''
        ? () => CommonHttp.request(
              HttpMethod.get,
              '${ApiUrls.signCheckId}/${user.id}',
              successFunction: (isAvailable) {
                // 성공일 경우
                if (isAvailable) {
                  setState(() {
                    _IsVerify.id = true;
                    _FocusNodes.password.requestFocus();
                  });
                }
                String text =
                    isAvailable ? '사용가능한 아이디 입니다.' : '사용 불가능한 아이디 입니다.';
                CommonDialog.show(titleText: text);
              },
            )
        : null;

    /// 이메일 버튼 pressed
    late Function()? onEmailButtonPressedFunc =
        (!_IsVerify.sendEmail && _IsVerify.email)
            ? () {
                CommonHttp.request(HttpMethod.post, ApiUrls.signSendmail,
                    data: user.toJson(), successFunction: (isSuccess) {
                  if (isSuccess) {
                    CommonDialog.show(titleText: '메일이 전송 됐습니다.');
                    setState(() {
                      _IsVerify.sendEmail = true;
                      _FocusNodes.code.requestFocus();
                    });
                  } else {
                    CommonDialog.show(titleText: '메일 전송이 실패했습니다.');
                  }
                });
              }
            : null;

    /// 인증코드 버튼 pressed
    late Function()? onCodeButtonPressedFunc =
        (_IsVerify.sendEmail && !_IsVerify.code && verifyCode != '')
            ? () {
                CommonHttp.request(HttpMethod.post, ApiUrls.signVerifyEmail,
                    data: {'email': user.email, 'code': verifyCode},
                    successFunction: (isSuccess) {
                  if (isSuccess) {
                    CommonDialog.show(titleText: '인증이 성공했습니다.');
                    setState(() {
                      _IsVerify.code = true;
                    });
                  } else {
                    CommonDialog.show(titleText: '인증이 실패했습니다.\n인증번호를 확인해주세요.');
                  }
                });
              }
            : null;

    return BackGroundContainer(
      isUseAppBar: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// 아이디
          CustomInput.renderInputFieldWithButton(
            CustomText.labelId,
            hintText: CustomMessage.hintId,
            CustomText.buttonId,
            onTextChangedFunc: onIdChangedFunc,
            onButtonPressedFunc: onIdButtonPressedFunc,
          ),

          /// 패스워드
          CustomInput.renderFullInputField(
            CustomText.labelPassword,
            hintText: CustomMessage.hintPassword,
            helperText: passwordHelperText,
            errorText: passwordErrorText,
            focusNode: _FocusNodes.password,
            onTextChangedFunc: onPasswordChangedFunc,
            isSecure: true,
          ),

          /// 패스워드 확인
          CustomInput.renderFullInputField(
            CustomText.labelPasswordConfirm,
            hintText: CustomMessage.hintPasswordConfirm,
            errorText: passwordConfirmErrorText,
            onTextChangedFunc: onPasswordConfirmChangedFunc,
            isSecure: true,
          ),

          /// 이메일
          CustomInput.renderInputFieldWithButton(
            CustomText.labelEmail,
            CustomText.buttonEmail,
            hintText: CustomMessage.hintEmail,
            errorText: emailErrorText,
            onTextChangedFunc: onEmailChangedFunc,
            onButtonPressedFunc: onEmailButtonPressedFunc,
          ),

          /// 인증 코드
          CustomInput.renderInputFieldWithButton(
            CustomText.labelVerifyCode,
            hintText: CustomMessage.hintVerifyCode,
            CustomText.confirm,
            onTextChangedFunc: onCodeChangedFunc,
            focusNode: _FocusNodes.code,
            onButtonPressedFunc: onCodeButtonPressedFunc,
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  CustomText.labelUserType,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Row(
                children: [
                  CustomInput.renderRadioButton(
                    UserType.N,
                    user.type,
                    UserType.N.korName,
                    onRadioSelected,
                  ),
                  CustomInput.renderRadioButton(
                    UserType.O,
                    user.type,
                    UserType.O.korName,
                    onRadioSelected,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            alignment: Alignment.center,
            child: CustomButton.renderSmallButton(
              CustomText.buttonSignUp,
              onButtonPressedFunc: (_IsVerify.id &&
                      _IsVerify.email &&
                      _IsVerify.sendEmail &&
                      _IsVerify.code)
                  ? () {
                      CommonHttp.request(HttpMethod.post, ApiUrls.signUp,
                          data: user.toJson(), successFunction: (isSuccess) {
                        if (isSuccess) {
                          SignIn.request(user.toJson());
                        }
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void verifyPassword() {
    if (passwordConfirmText != null && user.password != passwordConfirmText) {
      passwordConfirmErrorText = CustomMessage.errorPasswordConfirm;
    } else {
      passwordConfirmErrorText = null;
    }

    setState(() {});
  }

  void onRadioSelected(value) {
    setState(() => user.type = value);
  }
}
