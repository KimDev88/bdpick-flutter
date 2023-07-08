import 'package:bd_pick/component/common/navigation_service.dart';
import 'package:bd_pick/component/common/token_service.dart';
import 'package:bd_pick/const/const.dart';
import 'package:bd_pick/model/token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../const/enum.dart';
import 'common_dialog.dart';

class CommonHttp {
  static final BuildContext _context =
      NavigationService.navigatorKey.currentContext!;
  static final _options = BaseOptions(
    baseUrl: ApiUrls.apiUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 30),
  );
  static final dio = Dio(_options);

  static Future<void> _renewRequest(HttpMethod method, String path,
      {Object? data, Function(dynamic)? successFunction}) async {
    Token token = Token();
    token.accessToken = await TokenService.getAccessToken();
    token.refreshToken = await TokenService.getRefreshToken();

    CommonHttp.request(
      HttpMethod.post,
      ApiUrls.signRenew,
      data: token.toJson(),
      successFunction: (resData) {
        if (resData != null) {
          Map<String, dynamic> resultToken = resData[KeyNamesToken.token.name];
          // save tokens
          Token token = Token.fromJson(resultToken);
          TokenService.saveToken(token);
          return request(method, path,
              data: data, successFunction: successFunction);

          // save userType
          // String userTypeStr = data[KeyNamesUser.userType.name];
          // Prefs.setUserType(userTypeStr);
          // Prefs.setUserId(requestData[KeyNamesUser.id.name]);
        }
      },
    );
  }

  static void request(HttpMethod method, String path,
      {Object? data, Function(dynamic)? successFunction}) async {
    try {
      // dio.interceptors.add(LogInterceptor(
      // request: true,
      // requestBody: true,
      // responseBody: true,
      // requestHeader: true,
      // responseHeader: true,
      // error: true
      // ));
      CommonDialog.showProgress();

      // JWT token 설정
      Map<String, String> headerMap = {};
      String? accessToken = await TokenService.getAccessToken();
      if (accessToken != null) {
        headerMap['Authorization'] = 'Bearer $accessToken';
      }

      Response response;
      // 404
      switch (method) {
        case HttpMethod.get:
          response = await dio.get(path,
              options: Options(
                  contentType: Headers.jsonContentType, headers: headerMap));
          break;
        case HttpMethod.post:
          response = await dio.post(
            path,
            data: data,
            options: Options(
                contentType: Headers.jsonContentType, headers: headerMap),
            // contentType: Headers.multipartFormDataContentType, headers: headerMap),
            onSendProgress: (int sent, int total) {
              // print('$sent $total');
            },
          );
          break;
      }
      final resData = response.data;

      print('request data : $data');

      String resCode = resData['code'];
      String resMessage = resData['message'];
      print('response code : $resCode');
      print('response message : $resMessage');

      /// 성공일시
      if (resCode == "0000") {
        if (successFunction != null && response.data['data'] != null) {
          await successFunction(response.data['data']);
        }
      }

      /// 액세스 토큰 만료 시 갱신
      else if (resCode == "0410") {
        return _renewRequest(method, path,
            data: data, successFunction: successFunction);
      }

      /// 리프레시 토큰 만료 시 로그인 화면으로 이동
      else if (resCode == "0401") {
        CommonDialog.show(
          titleText: '인증정보가 만료되어 재로그인이 필요합니다.',
          onButtonPressedFunc: () {
            Navigator.of(_context)
                .pushNamedAndRemoveUntil(RouteKeys.signIn, (route) => false);
          },
        );
      } else {
        CommonDialog.show(titleText: resData['message']);
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;

      if (response != null) {
        CommonDialog.show(
            // titleText: '에러', contextText: '네트워크 통신 중 에러가 발생했습니다.');
            titleText: '에러',
            contextText: e.message);
        // print(response.data);
        // print(response.headers);
        // print(response.requestOptions);
        print('statusCode : ${response.statusCode}');
        print('statusMessage : ${response.statusMessage}');
        print('message : ${e.message}');
        print('responseData : ${e.response?.data}');
      }

      /// 서버 응답을 받지 못했을 경우
      else {
        CommonDialog.show(titleText: '에러', contextText: '서버와 통신이 실패했습니다.');
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.requestOptions);
        // print(e.message);
        print(e.error);
      }
    }
    // catch (e) {
    //   // print(e);
    // }
    finally {
      CommonDialog.closeProgress();
    }
  }
}
