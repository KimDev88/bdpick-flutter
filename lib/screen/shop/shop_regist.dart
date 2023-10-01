import 'package:bd_pick/component/background_container.dart';
import 'package:bd_pick/component/common/common_dialog.dart';
import 'package:bd_pick/component/common/common_http.dart';
import 'package:bd_pick/const/enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/custom_button.dart';
import '../../component/custom_input.dart';
import '../../const/const.dart';
import '../../const/message.dart';
import '../../const/text.dart';
import '../../model/shop.dart';

class ShopRegist extends StatefulWidget {
  const ShopRegist({super.key});

  @override
  State<StatefulWidget> createState() => ShopRegistState();
}

class ShopRegistState extends State<ShopRegist> {
  Shop shop = Shop();

  bool isFirst = false;
  bool isVerifyRegister = false;
  SharedPreferences prefs = Prefs.prefs!;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {


    /// 가게 아이디 있을 경우 수정화면
    if (prefs.containsKey(KeyNamesShop.id.name)) {
      shop.id = prefs.getInt(KeyNamesShop.id.name)!;

      shop.addressFullName = prefs.getString(KeyNamesShop.addressFullName.name)!;
      shop.addressName = prefs.getString(KeyNamesShop.addressName.name)!;
      shop.name = prefs.getString(KeyNamesShop.name.name)!;
      shop.ownerName = prefs.getString(KeyNamesShop.ownerName.name)!;
      shop.registerNumber = prefs.getString(KeyNamesShop.registerNumber.name)!;
      shop.type = prefs.getString(KeyNamesShop.type.name)!;
      shop.tel = prefs.getString(KeyNamesShop.tel.name)!;
    }

    setState(() {
      isFirst = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    /// 다음 버튼 pressed
    late Function()? onNextButtonPressedFunc = (isVerifyRegister &&
            shop.registerNumber != '' &&
            shop.name != '' &&
            shop.ownerName != '' &&
            shop.type != '' &&
            shop.tel != '' &&
            shop.addressFullName != '' &&
            shop.addressName != '')
        ? () => Navigator.pushNamed(context, RouteKeys.shopRegistSecond)
        : null;

    /// 사업자 버튼 확인 pressed
    late Function()? onVerifyButtonPressedFunc =
        (shop.registerNumber != '' && isVerifyRegister == false)
            ? () => CommonHttp.request(
                  HttpMethod.post,
                  ApiUrls.shopCheckRegister,
                  data: {KeyNamesShop.registerNumber.name: shop.registerNumber},
                  successFunction: (isVerify) {
                    if (isVerify) {
                      setState(() {
                        isVerifyRegister = true;
                      });
                      CommonDialog.show(titleText: '유효한 사업자 번호 입니다.');
                    }
                  },
                )
            : null;

    BackGroundContainer container = BackGroundContainer(
      isUseAppBar: true,
      titleText: '내가게 등록하기 Step1',
      child: Column(children: [
        const SizedBox(height: 10.0),
        /// 사업자등록번호
        CustomInput.renderInputFieldWithButton(
          '${CustomText.labelRegisterNumber}*',
          CustomText.confirm,
          keyboardType: TextInputType.number,
          hintText: CustomMessage.hintRegisterNumber,
          onTextChangedFunc: onRegisterNumberChangedFunc,
          onButtonPressedFunc: onVerifyButtonPressedFunc,
          controller: isFirst
              ? TextEditingController(
                  text: shop.registerNumber,
                )
              : null,
        ),
        CustomInput.renderFullInputField(
          '${CustomText.labelShopName}*',
          hintText: CustomMessage.hintShopName,
          onTextChangedFunc: onShopNameChangedFunc,
          controller: isFirst
              ? TextEditingController(
                  text: shop.name,
                )
              : null,
        ),
        CustomInput.renderFullInputField(
          '${CustomText.labelOwnerName}*',
          hintText: CustomMessage.hintOwnerName,
          onTextChangedFunc: onOwnerNameChangedFunc,
          controller: isFirst
              ? TextEditingController(
                  text: shop.ownerName,
                )
              : null,
        ),

        /// TODO 가게유형 추가
        CustomInput.renderFullInputField(
          '${CustomText.labelShopType}*',
          hintText: CustomMessage.hintShopType,
          onTextChangedFunc: onTypeChangedFunc,
          controller: isFirst
              ? TextEditingController(
                  text: shop.type,
                )
              : null,
        ),
        CustomInput.renderFullInputField(
          '${CustomText.labelTel}*',
          hintText: CustomMessage.hintTel,
          keyboardType: TextInputType.number,
          onTextChangedFunc: onTelChangedFunc,
          controller: isFirst
              ? TextEditingController(
                  text: shop.tel,
                )
              : null,
        ),
        // CustomInput.renderLabel('${CustomText.labelAddress}*'),
        CustomInput.renderFullInputField(
          '${CustomText.labelAddress}*',
          onTextChangedFunc: onAddressChangedFunc,
          controller: isFirst
              ? TextEditingController(text: shop.addressFullName)
              : null,
        ),
        CustomInput.renderFullInputField(
          '',
          hintText: CustomMessage.hintAddressDetail,
          onTextChangedFunc: onAddressDetailChangedFunc,
          controller:
              isFirst ? TextEditingController(text: shop.addressName) : null,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton.renderSmallButton(
              CustomText.next,
              onButtonPressedFunc: onNextButtonPressedFunc,
            ),
            const SizedBox(
              width: 10.0,
            )
          ],
        )
      ]),
    );
    if (isFirst) {
      isFirst = !isFirst;
    }
    return container;
  }

  late Function(String) onRegisterNumberChangedFunc = (value) {
    setState(() {
      isVerifyRegister = false;
      shop.registerNumber = value;
      prefs.setString(KeyNamesShop.registerNumber.name, value);
    });
  };

  late Function(String) onShopNameChangedFunc = (value) {
    setState(() {
      shop.name = value;
      prefs.setString(KeyNamesShop.name.name, value);
    });
  };

  late Function(String) onOwnerNameChangedFunc = (value) {
    setState(() {
      shop.ownerName = value;
      prefs.setString(KeyNamesShop.ownerName.name, value);
    });
  };

  late Function(String) onTypeChangedFunc = (value) {
    setState(() {
      shop.type = value;
      prefs.setString(KeyNamesShop.type.name, value);
    });
  };

  late Function(String) onTelChangedFunc = (value) {
    setState(() {
      shop.tel = value;
      prefs.setString(KeyNamesShop.tel.name, value);
    });
  };

  late Function(String) onAddressChangedFunc = (value) {
    setState(() {
      shop.addressFullName = value;
      prefs.setString(KeyNamesShop.addressFullName.name, value);
    });
  };

  late Function(String) onAddressDetailChangedFunc = (value) {
    setState(() {
      shop.addressName = value;
      prefs.setString(KeyNamesShop.addressName.name, value);
    });
  };
}
