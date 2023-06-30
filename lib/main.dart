import 'package:bd_pick/screen/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'component/common/navigation_service.dart';
import 'component/common/routes.dart';
import 'const/const.dart';

void main() {
  runApp(
    MaterialApp(
      home: const Intro(),
      // home: AdMain(),
      navigatorKey: NavigationService.navigatorKey,
      routes: Routes.getRoutes(),
      builder: EasyLoading.init(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(

          labelSmall: TextStyle(
              color: BdColors.fontColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
