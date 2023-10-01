import 'dart:convert';

import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/common/common_dialog.dart';
import 'package:bd_pick/component/common/common_http.dart';
import 'package:bd_pick/component/custom_button.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:bd_pick/const/const.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:bd_pick/model/shop_ad.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/custom_layout.dart';

class CreateAd extends StatefulWidget {
  final String? restorationId;

  const CreateAd({super.key, this.restorationId});

  @override
  State<StatefulWidget> createState() => _CreateAdState();
}

enum _ImageKeys { A1 }

class _CreateAdState extends State<CreateAd> with RestorationMixin {
  String? startDateStr;
  String? endDateStr;
  static DateTime startDate = DateTime.now().add(const Duration(hours: 1));
  static DateTime? endDate;
  final ShopAd _shopAd = ShopAd();
  Map<String, dynamic> inputMap = {};
  List<ShopAd> adList = [];

  // String? shopName = Prefs.prefs!.getString(KeyNamesShop.name.name);
  String? shopName = 'test';
  Images images = Images();
  late final ImagePickWidget imagePickWidget;
  TextEditingController branchController = TextEditingController();
  TextEditingController startedAtController = TextEditingController();
  TextEditingController endedAtController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController keywordController = TextEditingController();

  _CreateAdState() {
    imagePickWidget = ImagePickWidget(this);
  }

  void Function() inputListener(
      KeyNamesShopAd key, TextEditingController controller) {
    return () {
      inputMap[key.name] = controller.value.text;
      print(inputMap[key.name]);
    };
  }

  void Function() inputDateListener(
      KeyNamesShopAd key, TextEditingController controller) {
    return () {
      if (key == KeyNamesShopAd.startedAt && startDateStr != null) {
        controller.value = TextEditingValue(text: startDateStr!);
        inputMap['${key.name}Date'] = startDate;
      } else if (key == KeyNamesShopAd.endedAt && endDateStr != null) {
        controller.value = TextEditingValue(text: endDateStr!);
        inputMap['${key.name}Date'] = endDate;
      }
      inputMap[key.name] = controller.value.text;
    };
  }

  @override
  void initState() {
    super.initState();
    // text controller binding
    branchController.addListener(
        inputListener(KeyNamesShopAd.branchName, branchController));
    startedAtController.addListener(
        inputDateListener(KeyNamesShopAd.startedAt, startedAtController));
    endedAtController.addListener(
        inputDateListener(KeyNamesShopAd.endedAt, endedAtController));
    contentController
        .addListener(inputListener(KeyNamesShopAd.content, contentController));
    keywordController
        .addListener(inputListener(KeyNamesShopAd.keyword, keywordController));

    // date 초기화
    startDate = DateTime.now().add(const Duration(hours: 1));
    endDate = null;

    // 내 매장 광고 데이터 조회
    CommonHttp.request(
      HttpMethod.get,
      ApiUrls.shopAds,
      data: null,
      successFunction: (data) {
        // List adList = data as List;
        data.forEach((element) {
          adList.add(ShopAd.fromJson(element));
        });
        setState(() {});

        // List<ShopAd> shopAd = ShopAd.fromJson(data);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    branchController.dispose();
    startedAtController.dispose();
    endedAtController.dispose();
    contentController.dispose();
    keywordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
        isUseHeight: true,
        titleText: '내가게 홍보하기',
        isUseAppBar: true,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: imagePickWidget.renderImageWidget(
                      _ImageKeys.A1.name, '홍보 할 이미지를 추가해 주세요.'),
                ),
              ],
            ),
            Card(
              margin: const EdgeInsetsDirectional.all(10.0),
              child: Column(
                children: [
                  renderRow('상호명*', '상호명을 입력해주세요',
                      readOnly: true,
                      controller: shopName != null
                          ? TextEditingController(text: shopName)
                          : null),
                  renderRow('지점*', '지점을 입력해주세요', controller: branchController),
                  renderDatePickerRow('기간*'),
                  renderRow('행사내용*', '행사내용을 입력해주세요',
                      controller: contentController),
                  renderRow('키워드*', '#소고기 #세일 #고기',
                      controller: keywordController),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomButton.renderSmallButton(
                    '홍보하기',
                    onButtonPressedFunc: () async {
                      List? startedAt = startDateStr?.split('.');
                      List? endedAt = endDateStr?.split('.');
                      DateTime startedAtDate = DateTime(
                          int.parse(startedAt?[0]),
                          int.parse(startedAt?[1]),
                          int.parse(startedAt?[2]));
                      DateTime endedAtDate = DateTime(int.parse(endedAt?[0]),
                          int.parse(endedAt?[1]), int.parse(endedAt?[2]));
                      // _shopAd.startedAt = inputMap[KeyNamesShopAd.startedAt];
                      // _shopAd.endedAt = inputMap[KeyNamesShopAd.endedAt];
                      _shopAd.startedAt = startedAtDate;
                      _shopAd.endedAt = endedAtDate;
                      _shopAd.content = inputMap[KeyNamesShopAd.content.name];
                      _shopAd.branchName =
                          inputMap[KeyNamesShopAd.branchName.name];
                      String keyword = inputMap[KeyNamesShopAd.keyword.name];
                      List<String> keywordList = keyword.split('#');
                      keywordList.removeWhere((element) => element == '');
                      _shopAd.keywordList = keywordList;

                      Map<String, dynamic> data = {};
                      XFile? image =
                          imagePickWidget.images.getImage(_ImageKeys.A1.name);
                      if (image == null) {
                        CommonDialog.show(titleText: '이미지를 선택해주세요');
                        return;
                      }

                      data.addAll({
                        'shopAd': MultipartFile.fromString(
                            jsonEncode(_shopAd.toJson()),
                            contentType: MediaType.parse('application/json')),
                        'files': [
                          await MultipartFile.fromFile(image.path,
                              contentType: MediaType('image', 'jpg')),
                        ],
                        'fileTypes': [_ImageKeys.A1.name],
                      });

                      FormData formData = FormData.fromMap(data);
                      CommonHttp.request(
                        HttpMethod.post,
                        ApiUrls.shopAds,
                        data: formData,
                        successFunction: (data) {
                          if (data != null) {
                            CommonDialog.show(
                                titleText: '등록 되었습니다.',
                                onButtonPressedFunc: () {
                                  // initState();
                                  Navigator.popAndPushNamed(
                                      context, RouteKeys.createAd);
                                  // Navigator.pushReplacementNamed(
                                  //     context, RouteKeys.createAd);
                                });
                          }
                        },
                      );
                      print(_shopAd);
                    },
                  ),
                ),
              ],
            ),
            (adList.length > 0)
                ? Expanded(
                    child: GridView.builder(
                      // itemCount: widget.selectedList.length,
                      itemCount: adList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.7, crossAxisCount: 2),
                      itemBuilder: (_, int index) {
                        ShopAd ad = adList[index];
                        return InkWell(
                          // onTap: () => _toggle(index),
                          // onLongPress: () {
                          //   if (!widget.isSelectionMode) {
                          //     setState(() {
                          //       widget.selectedList[index] = true;
                          //     });
                          //     widget.onSelectionChange!(true);
                          //   }
                          // },
                          child: GridTile(

                              //   child: Container(
                              // // child: widget.isSelectionMode
                              // //     ? Checkbox(
                              // //         onChanged: (bool? x) => _toggle(index),
                              // //         value: widget.selectedList[index])
                              // //     : const Icon(Icons.image),
                              child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(ad.fileUri!, fit: BoxFit.fill),
                                Text(ad.branchName),
                                Text('${formatDate(ad.startedAt, [
                                      yyyy,
                                      '-',
                                      mm,
                                      '-',
                                      dd
                                    ])} ~ ${formatDate(ad.endedAt, [
                                      yyyy,
                                      '-',
                                      mm,
                                      '-',
                                      dd
                                    ])}'),
                                Text(ad.content),
                                Text(ad.keywords!),
                              ],
                            ),
                          )),
                        );
                        // );
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ));
  }

  void openStartPicker() {
    _restorableStartDatePickerRouteFuture.present();
  }

  void openEndPicker() {
    _restorableEndDatePickerRouteFuture.present();
  }

  Widget renderRow(
    String labelText,
    String hintText, {
    TextEditingController? controller,
    bool readOnly = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 2,
          child: CustomInput.renderLabel(
            text: Text(
              labelText,
              style: const TextStyle(fontSize: 15.0),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: CustomInput.renderInputField(
            textStyle: TextStyles.inputTextLabel,
            hintText: hintText,
            hintStyle: TextStyles.hintLabelSmall,
            controller: controller,
            readOnly: readOnly,
            suffixIcon: !readOnly
                ? const Icon(
                    Icons.close_sharp,
                    color: BdColors.buttonColor,
                  )
                : null,
          ),
        )
      ],
    );
  }

  Widget renderDatePickerRow(
    String labelText,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 2,
          child: CustomInput.renderLabel(
            text: Text(
              labelText,
              style: const TextStyle(fontSize: 15.0),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  child: CustomInput.renderInputField(
                    readOnly: true,
                    controller: startedAtController,
                    hintText: '시작일',
                    hintStyle: TextStyles.hintLabelSmall,
                    textStyle: const TextStyle(
                        fontSize: 15.0,
                        color: BdColors.buttonColor,
                        fontWeight: FontWeight.w600),
                    onTapFunction: () {
                      openStartPicker();
                    },
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '~',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: BdColors.buttonColor,
                        fontWeight: FontWeight.w600),
                  )),
              Expanded(
                child: CustomInput.renderInputField(
                  readOnly: true,
                  controller: endedAtController,
                  hintText: '종료일',
                  hintStyle: TextStyles.hintLabelSmall,
                  textStyle: const TextStyle(
                      fontSize: 15.0,
                      color: BdColors.buttonColor,
                      fontWeight: FontWeight.w600),
                  onTapFunction: () {
                    openEndPicker();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _selectStartDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate;
        startDate = newSelectedDate;
        startDateStr = formatDate(newSelectedDate, [yyyy, '.', mm, '.', dd]);
        startedAtController.notifyListeners();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_startDate.value.day}/${_startDate.value.month}/${_startDate.value.year}'),
        // ));
      });
    }
  }

  void _selectEndDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _endDate.value = newSelectedDate;
        endDate = newSelectedDate;
        endDateStr = formatDate(newSelectedDate, [yyyy, '.', mm, '.', dd]);
        endedAtController.notifyListeners();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_startDate.value.day}/${_startDate.value.month}/${_startDate.value.year}'),
        // ));
      });
    }
  }

  final RestorableDateTime _startDate = RestorableDateTime(DateTime.now());
  final RestorableDateTime _endDate =
      RestorableDateTime(DateTime.now().add(const Duration(hours: 1)));

  late final RestorableRouteFuture<DateTime?>
      _restorableStartDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
    onComplete: _selectStartDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _startDatePickerRoute,
        arguments: _startDate.value.millisecondsSinceEpoch,
      );
    },
  );

  late final RestorableRouteFuture<DateTime?>
      _restorableEndDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
    onComplete: _selectEndDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _endDatePickerRoute,
        arguments: _endDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _startDatePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.timestamp();
        return DatePickerDialog(
            restorationId: 'start_date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: startDate,
            firstDate: startDate,
            lastDate: endDate ?? now.add(const Duration(days: 365)));
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<DateTime> _endDatePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.timestamp();
        return DatePickerDialog(
            restorationId: 'end_date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            // initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
            initialDate: startDate,
            firstDate: startDate,
            lastDate: now.add(const Duration(days: 365)));
      },
    );
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'selected_start_date');
    registerForRestoration(_endDate, 'selected_end_date');
    registerForRestoration(_restorableStartDatePickerRouteFuture,
        'start_date_picker_route_future');
    registerForRestoration(
        _restorableEndDatePickerRouteFuture, 'end_date_picker_route_future');
  }
}
