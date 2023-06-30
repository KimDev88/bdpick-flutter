import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/common/custom_util.dart';
import 'package:bd_pick/const/const.dart';
import 'package:bd_pick/model/shop.dart';
import 'package:bd_pick/screen/shop/shop_regist.dart';
import 'package:flutter/material.dart';

import '../../component/common/common_http.dart';
import '../../const/enum.dart';

class ShopMain extends StatefulWidget {
  const ShopMain({super.key});

  @override
  State<StatefulWidget> createState() => _ShopMainState();
}

class _ShopMainState extends State<ShopMain> {
  String upsertStr = '내가게 등록하기';

  @override
  void initState() {
    super.initState();

    CommonHttp.request(HttpMethod.get, ApiUrls.shopThis,
        successFunction: (data) {
      if (data != null) {
        if (data['id'] != null) {
          setState(() {
            Prefs.prefs!.setInt(KeyNamesShop.id.name, data['id']);
            Prefs.setPrefs(data);
            upsertStr = '내가게 수정하기';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prefs.initializePrefs();
    Size size = CustomUtil.getContextSize();
    TextStyle textStyle = const TextStyle(fontSize: 20.0, color: Colors.white);

    double width = (size.width / 2.0) - 20.0;
    double height = (size.height / 2.0 - 60.0) - 20.0;

    return BackGroundContainer(
        isUseAppBar: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: BdColors.buttonColor,
                  width: width,
                  height: height,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteKeys.shopRegist),
                    child: Text(upsertStr, style: textStyle),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: BdColors.buttonColor,
                  width: width,
                  height: height,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteKeys.shopMain);
                    },
                    child: Text("내가게 홍보하기", style: textStyle),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: BdColors.buttonColor,
                  width: width,
                  height: height,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteKeys.createAd);
                    },
                    child: Text("내가게 관리하기", style: textStyle),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
