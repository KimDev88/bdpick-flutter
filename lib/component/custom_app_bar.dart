import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import '../const/message.dart';

class CustomAppBar {
  static final BuildContext _context =
      NavigationService.navigatorKey.currentContext!;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static double leadingItemWidth = 35.0;

  static double getLeadingWidth() {
    bool isCanPop = Navigator.canPop(_context);
    bool isSignIn = Prefs.getUserId() != null;

    return (isCanPop ? leadingItemWidth : 0) +
        (isSignIn ? leadingItemWidth : 0);
  }

  static void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  static Widget getLeadingWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Navigator.canPop(_context)
          ? SizedBox(
              width: leadingItemWidth,
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                // style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero), fixedSize: MaterialStatePropertyAll(Size(10,10))),
                onPressed: () {
                  Navigator.pop(_context);
                },
                icon: const Icon(Icons.arrow_back_sharp),
              ),
            )
          : const SizedBox.shrink(),
      Prefs.getUserId() != null
          ? Container(
              margin: EdgeInsetsDirectional.all(0),
              width: leadingItemWidth,
              child: IconButton(
                  // padding: EdgeInsetsDirectional.all(0.0),
                  onPressed: () {
                    openDrawer();
                  },
                  icon: const Icon(Icons.menu)))
          : const SizedBox.shrink(),
    ]);
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
        primary: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: BdColors.buttonColor,
        shadowColor: Colors.white,
        // titleSpacing: 5,
        leadingWidth: getLeadingWidth(),
        leading: getLeadingWidget(),
        title: Row(
          // mainAxisAlignment:
          // canPop ? MainAxisAlignment.start : MainAxisAlignment.center,
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

  static PreferredSizeWidget? renderSearchAppBar(
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
        leadingWidth: getLeadingWidth(),
        titleSpacing: 5,
        leading: getLeadingWidget(),
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
