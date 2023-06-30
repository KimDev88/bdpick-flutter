import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import '../const/message.dart';

class CustomAppBar {
  static final BuildContext _context =
      NavigationService.navigatorKey.currentContext!;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  /// Custom AppBar를 그린다.
  /// [isUseAppBar] 가 true일 경우에만 그린다.
  static PreferredSizeWidget? renderAppBar(
    bool isUseAppBar, {
    String? titleText,
  }) {
    bool canPop = Navigator.canPop(_context);
    if (isUseAppBar) {
      return AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: BdColors.buttonColor,
        shadowColor: Colors.white,
        titleSpacing: 5,
        title: Row(
          mainAxisAlignment:
              canPop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Text(
              titleText ?? CustomMessage.intro,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      );
    }
    return null;
  }

  static PreferredSizeWidget? renderSigninAppBar(
    bool isUseAppBar, {
    PreferredSizeWidget? bottom,
  }) {
    if (isUseAppBar) {
      return AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        // automaticallyImplyLeading: true,
        backgroundColor: BdColors.buttonColor,
        shadowColor: Colors.white,
        // leadingWidth: 50,
        titleSpacing: 5,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // IconButton(
              //   onPressed: () {
              //     openDrawer();
              //     Navigator.pushNamed(_context, RouteKeys.adMain);
              //   },
              //   icon: const Icon(Icons.menu),
              // ),
              Container(
                width: 300,
                child: CustomInput.renderInputFieldWithPadding(
                    hintText: CustomMessage.hintSearchAd,
                    suffixIcon: const Icon(Icons.search_outlined)),
              )
            ],
          ),
        ),

        bottom: bottom,
      );
    }
    return null;
  }
}
