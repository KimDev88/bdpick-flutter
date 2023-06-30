import 'package:flutter/material.dart';

import '../../component/background_container.dart';
import '../../component/custom_button.dart';
import '../../component/custom_layout.dart';
import '../../const/const.dart';

class SignUpComplete extends StatelessWidget {
  const SignUpComplete({super.key});



  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
      isUseAppBar: false,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple, Colors.purple[300]!, Colors.purple[100]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height / 3.0,
            child: Column(
              children: [
                CustomLayout.renderLogo(),
                const Text(
                  textAlign: TextAlign.center,
                  '광고는 유용하다.\n내가 원하는 광고만 골라볼까?',
                  style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 300,
          ),
          SizedBox(
            // height: MediaQuery.of(context).size.height / 3.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 40.0),
                  child: CustomButton.renderSmallButton(
                    '시작하기',
                    onButtonPressedFunc: () =>
                        Navigator.pushNamed(
                            context, RouteKeys.signIn),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
