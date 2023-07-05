import 'package:bd_pick/component/common/token_service.dart';
import 'package:bd_pick/component/custom_button.dart';
import 'package:bd_pick/const/const.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class BackGroundContainer extends StatelessWidget {
  final Widget child;
  final bool isUseAppBar;
  final AppBarType appBarType;
  final PreferredSizeWidget? bottom;
  final String? titleText;
  final Decoration? decoration;
  final bool isUseHeight;
  final String? restorationId;

  const BackGroundContainer({
    super.key,
    required this.child,
    this.isUseAppBar = false,
    this.appBarType = AppBarType.isNotSigned,
    this.bottom,
    this.titleText,
    this.decoration,
    this.isUseHeight = false,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? renderAppBar;

    switch (appBarType) {
      case AppBarType.isNotSigned:
        renderAppBar =
            CustomAppBar.renderAppBar(isUseAppBar, titleText: titleText);
        break;
      case AppBarType.isSigned:
        renderAppBar =
            CustomAppBar.renderSearchAppBar(isUseAppBar, bottom: bottom);
        break;
    }

    double minHeight;
    if (isUseAppBar) {
      minHeight = MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          40;
      // height = MediaQuery.of(context).size.height;
    } else {
      minHeight = MediaQuery.of(context).size.height;
    }

    const List<ExampleDestination> destinations = <ExampleDestination>[
      ExampleDestination(
          'page 0', Icon(Icons.widgets_outlined), Icon(Icons.widgets)),
      ExampleDestination('page 1', Icon(Icons.format_paint_outlined),
          Icon(Icons.format_paint)),
      ExampleDestination('page 2', Icon(Icons.text_snippet_outlined),
          Icon(Icons.text_snippet)),
      ExampleDestination(
          'page 3', Icon(Icons.invert_colors_on_outlined), Icon(Icons.opacity)),
    ];

    return Scaffold(
        // input focus 시 레이아웃 변경 방지
        // resizeToAvoidBottomInset: false,
        restorationId: restorationId,
        appBar: renderAppBar,
        drawer: Prefs.getUserId() != null
            ? NavigationDrawer(
                // onDestinationSelected: handleScreenChanged,
                // selectedIndex: screenIndex,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              Prefs.getUserId()!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          CustomButton.renderCustomButton(
                              '로그아웃', const Size(15, 30),
                              onButtonPressedFunc: () {
                            Prefs.clear();
                            TokenService.clear();
                            Navigator.pushNamedAndRemoveUntil(
                                context, RouteKeys.main, (route) => false);
                          }),
                        ],
                      )),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
                    child: Divider(),
                  ),
                  // ...destinations.map(
                  //   (ExampleDestination destination) {
                  //     return NavigationDrawerDestination(
                  //       label: Text(destination.label),
                  //       icon: destination.icon,
                  //       selectedIcon: destination.selectedIcon,
                  //     );
                  //   },
                  // ),
                ],
              )
            : null,
        body: Builder(
          builder: (context) {
            CustomAppBar.setContext(context);
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: isUseHeight ? minHeight : null,
                constraints: BoxConstraints(
                  minHeight: minHeight,
                ),
                decoration: decoration,
                child: child,
              ),
            );
          },
        ));
  }
}
