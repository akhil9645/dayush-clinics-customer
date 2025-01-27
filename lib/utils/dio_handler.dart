import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

var baseUrl = "http://192.168.1.8:8000/";

class DioHandler {
  static final Dio dio = Dio();

  static Future<dynamic> dioPOST({dynamic body, String? endpoint}) async {
    Map<String, dynamic> headers = {
      "content-type": "application/json",
    };
    var combinedurl = baseUrl + endpoint!;
    print(combinedurl);
    DioHandler.dio.options.headers.addAll(headers);
    try {
      Response response;

      response = await DioHandler.dio
          .post(
            combinedurl,
            data: body,
          )
          .timeout(const Duration(seconds: 60));
      print(response);

      return response.data;
    } catch (e) {
      log("DioError: $e");
      return e;
    }
  }

  static Future<dynamic> dioGET({
    dynamic body,
  }) async {
    Map<String, dynamic> headers = {
      "content-type": "application/json",
    };
    DioHandler.dio.options.headers.addAll(headers);
    try {
      Response response;

      response = await DioHandler.dio
          .get(baseUrl, data: body)
          .timeout(const Duration(seconds: 60));

      return response.data;
    } catch (e) {
      log("DioError: $e");
      return e;
    }
  }
}
