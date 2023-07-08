import 'dart:async';

import 'package:bd_pick/component/common/sign_service.dart';
import 'package:bd_pick/const/const.dart';
import 'package:flutter/material.dart';

import '../component/background_container.dart';
import '../component/custom_layout.dart';
import '../const/message.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<StatefulWidget> createState() => IntroState();
}

class IntroState extends State<Intro> {


  @override
  Widget build(BuildContext context) {
    Prefs.initializePrefs();
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
          CustomLayout.renderLogo(),
          const Text(
            CustomMessage.intro,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      // 로그인 정보가 존재할 경우
      if(Prefs.getUserId() != null){
        SignService.navigateToMainsByPrefs();
      } else {
        Navigator.pushReplacementNamed(context, RouteKeys.main);
      }
    });
  }
}
