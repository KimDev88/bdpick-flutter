import 'dart:io';

import 'package:bd_pick/component/common/token_service.dart';
import 'package:bd_pick/const/const.dart';
import 'package:dio/dio.dart';

import '../../const/enum.dart';
import 'common_dialog.dart';

class CommonHttp {
  static final _options = BaseOptions(
    baseUrl: ApiUrls.apiUrl,
    connectTimeout: const Duration(seconds: 5),
    // receiveTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 30),
  );
  static final dio = Dio(_options);

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
              print('$sent $total');
            },
          );
          break;
      }
      final resData = response.data;
      print(data.toString());

      print(data);
      /// 성공일시
      if (resData['code'] == "0000") {
        if (successFunction != null && response.data['data'] != null) {
          await successFunction(response.data['data']);
        }
      } else if (resData['message'] != null) {
        // CommonDialog.show(titleText: '에러', contextText: resData['message']);
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
        print(response.statusCode);
        print(response.statusMessage);
        print(e.message);
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
