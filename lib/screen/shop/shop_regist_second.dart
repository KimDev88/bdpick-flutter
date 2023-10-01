import 'dart:convert';
import 'dart:io';

import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:bd_pick/model/shop.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/common/common_http.dart';
import '../../component/common/custom_util.dart';
import '../../component/custom_button.dart';
import '../../component/custom_layout.dart';
import '../../const/const.dart';
import '../../const/enum.dart';
import '../../const/text.dart';

class ShopRegistSecond extends StatefulWidget {
  const ShopRegistSecond({super.key});

  @override
  State<StatefulWidget> createState() => ShopRegistSecondState();
}

class _Images {
  static Map<String, XFile> imageMap = {};

  static void setImage(String key, XFile? image) {
    imageMap[key] = image!;
  }

  static XFile? getImage(String key) {
    return imageMap[key];
  }
}

enum _ImageKeys { image1, image2, image3, image4 }

class ShopRegistSecondState extends State<ShopRegistSecond> {
  Size size = CustomUtil.getContextSize();
  TextStyle? textStyle = TextStyles.imageWidgetLabel;
  double? width;
  double? height;
  late final ImagePickWidget imagePickWidget;

  ShopRegistSecondState() {
    imagePickWidget = ImagePickWidget(this);
  }

  @override
  void initState() {
    super.initState();
    width = (size.width / 2.0) - 20.0;
    height = (size.height / 3.0 - 60.0) - 60.0;
  }

  // Image _renderPickedImage(String imagePath) {
  //   return Image.file(File(imagePath), fit: BoxFit.cover);
  // }
  //
  // Widget renderImageWidget(String imageKey, String text) {
  //   XFile? image = _Images.getImage(imageKey);
  //   return InkWell(
  //     onTap: () async {
  //       XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //       _Images.setImage(imageKey, image);
  //       setState(() {});
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
  //       // color: image == null ? Colors.pink : null,
  //       width: width,
  //       height: height,
  //       child: Card(
  //         child: image == null
  //             ? Column(
  //                 children: [
  //                   addIcon,
  //                   Text(text, style: textStyle),
  //                 ],
  //               )
  //             : _renderPickedImage(image.path),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // XFile? image1 = _Images.getImage(_ImageKeys.image1.name);
    // XFile? image2 = _Images.getImage(_ImageKeys.image2.name);
    // XFile? image3 = _Images.getImage(_ImageKeys.image3.name);
    // XFile? image4 = _Images.getImage(_ImageKeys.image4.name);
    XFile? image1 = imagePickWidget.images.getImage(_ImageKeys.image1.name);
    XFile? image2 = imagePickWidget.images.getImage(_ImageKeys.image2.name);
    XFile? image3 = imagePickWidget.images.getImage(_ImageKeys.image3.name);
    XFile? image4 = imagePickWidget.images.getImage(_ImageKeys.image4.name);

    /// 다음 버튼 pressed
    late Function()? onCompleteButtonPressedFunc =
        (image1 != null && image2 != null && image3 != null && image4 != null)
            ? () async {
                Shop shop = Shop();
                shop.name = Prefs.prefs!.getString(KeyNamesShop.name.name)!;
                shop.type = Prefs.prefs!.getString(KeyNamesShop.type.name)!;
                shop.addressName =
                    Prefs.prefs!.getString(KeyNamesShop.addressName.name)!;
                shop.addressFullName =
                    Prefs.prefs!.getString(KeyNamesShop.addressFullName.name)!;
                shop.ownerName =
                    Prefs.prefs!.getString(KeyNamesShop.ownerName.name)!;

                shop.registerNumber =
                    Prefs.prefs!.getString(KeyNamesShop.registerNumber.name)!;
                shop.tel = Prefs.prefs!.getString(KeyNamesShop.tel.name)!;

                Map<String, dynamic> data = {};
                data.addAll({
                  'files': [
                    await MultipartFile.fromFile(image1.path,
                        contentType: MediaType('image', 'jpg')),
                    await MultipartFile.fromFile(image2.path,
                        contentType: MediaType('image', 'jpg')),
                    await MultipartFile.fromFile(image3.path,
                        contentType: MediaType('image', 'jpg')),
                    await MultipartFile.fromFile(image4.path,
                        contentType: MediaType('image', 'jpg')),
                  ],
                  'fileTypes': ['S1', 'S2', 'S3', 'S4'],
                  'shop': MultipartFile.fromString(jsonEncode(shop.toJson()),
                      contentType: MediaType.parse('application/json')),
                });

                FormData formData = FormData.fromMap(data);
                CommonHttp.request(
                  HttpMethod.post,
                  ApiUrls.shops,
                  data: formData,
                  successFunction: (isSuccess) {
                    if (isSuccess != null) {
                      Prefs.clearShopSignPrefs();
                      Navigator.pushNamedAndRemoveUntil(
                          context, RouteKeys.shopMain, (route) => false);
                    }
                  },
                );
              }
            : null;

    // textStyle = const TextStyle(fontSize: 15.0, color: Colors.white);
    return BackGroundContainer(
        isUseAppBar: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: CustomInput.renderLabel(labelText: '가게정보*'),
            ),
            Row(
              children: [
                imagePickWidget.renderImageWidget(
                    _ImageKeys.image1.name, '가게 정면사진 등록을 추천해요'),
                imagePickWidget.renderImageWidget(
                    _ImageKeys.image2.name, '메뉴 & 가격 등록을 추천해요'),
              ],
            ),
            Row(
              children: [
                imagePickWidget.renderImageWidget(
                    _ImageKeys.image3.name, '인기 메뉴 등록을 추천해요'),
                imagePickWidget.renderImageWidget(
                    _ImageKeys.image4.name, '추천 메뉴 등록을 추천해요'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton.renderSmallButton(
                  CustomText.complete,
                  onButtonPressedFunc: onCompleteButtonPressedFunc,
                ),
                const SizedBox(
                  width: 10.0,
                )
              ],
            )
          ],
        ));
  }
}
