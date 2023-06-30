import 'dart:io';

import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../const/const.dart';
import 'common/custom_util.dart';

class CustomLayout {
  static BuildContext context = NavigationService.navigatorKey.currentContext!;

  static Widget renderLogo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'B',
            style: TextStyle(
              color: Colors.white,
              fontSize: 150,
              fontWeight: FontWeight.w400,
            ),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              'D',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 140,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class Images {
  Map<String, XFile> imageMap = {};

  void setImage(String key, XFile? image) {
    imageMap[key] = image!;
  }

  XFile? getImage(String key) {
    return imageMap[key];
  }
}

class ImagePickWidget{
  final ImagePicker picker = ImagePicker();
  final Size size = CustomUtil.getContextSize();
  Images images = Images();
  final State state;

  ImagePickWidget(this.state);

  TextStyle textStyle = TextStyles.imageWidgetLabel;
  Icon addIcon = const Icon(
      color: BdColors.buttonColor,
      Icons.add_box_outlined,
      // grade: ,
      weight: 0.1,
      // fill: 0.1,
      size: 110);

  Image _renderPickedImage(String imagePath) {
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }

  Widget renderImageWidget(String imageKey, String text) {
    double width = (size.width / 2.0) - 20.0;
    double height = (size.height / 3.0 - 60.0) - 60.0;
    // NavigatorState state = NavigationService.navigatorKey.currentState!;

    XFile? image = images.getImage(imageKey);
    return InkWell(
      onTap: () async {
        XFile? image = await picker.pickImage(source: ImageSource.gallery);
        images.setImage(imageKey, image);
        state.setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        // color: image == null ? Colors.pink : null,
        width: width,
        height: height,
        child: Card(
          child: image == null
              ? Column(
                  children: [
                    addIcon,
                    Text(text, style: textStyle),
                  ],
                )
              : _renderPickedImage(image.path),
        ),
      ),
    );
  }
}
