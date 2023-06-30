import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/custom_button.dart';
import 'package:bd_pick/component/custom_input.dart';
import 'package:bd_pick/const/const.dart';
import 'package:bd_pick/model/shop.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../../component/custom_layout.dart';

class CreateAd extends StatefulWidget {
  final String? restorationId;

  const CreateAd({super.key, this.restorationId});

  @override
  State<StatefulWidget> createState() => _CreateAdState();
}

class _CreateAdState extends State<CreateAd> with RestorationMixin {
  String? startDateStr;
  String? endDateStr;
  static DateTime startDate = DateTime.now().add(const Duration(hours: 1));
  static DateTime? endDate;
  String? shopName = Prefs.prefs!.getString(KeyNamesShop.name.name);
  Images images = Images();
  late final ImagePickWidget imagePickWidget;

  _CreateAdState() {
    imagePickWidget = ImagePickWidget(this);
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundContainer(
        titleText: '내가게 홍보하기',
        isUseAppBar: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: imagePickWidget.renderImageWidget(
                      'test', '홍보 할 이미지를 추가해 주세요.'),
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
                  renderRow('지점*', '지점을 입력해주세요'),
                  renderDatePickerRow('기간*'),
                  renderRow('행사내용*', '행사내용을 입력해주세요'),
                  renderRow('키워드*', '#소고기 #세일 #고기'),
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
                    onButtonPressedFunc: () {},
                  ),
                ),
              ],
            )
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
                    controller: TextEditingController(text: startDateStr),
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
                  controller: TextEditingController(text: endDateStr),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_startDate.value.day}/${_startDate.value.month}/${_startDate.value.year}'),
        ));
      });
    }
  }

  void _selectEndDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _endDate.value = newSelectedDate;
        endDate = newSelectedDate;
        endDateStr = formatDate(newSelectedDate, [yyyy, '.', mm, '.', dd]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_startDate.value.day}/${_startDate.value.month}/${_startDate.value.year}'),
        ));
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
