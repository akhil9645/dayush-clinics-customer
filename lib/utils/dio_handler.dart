import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

var baseUrl =
    "https://871d-2401-4900-1cde-c6d2-2065-ccd6-46f-b995.ngrok-free.app/";

class DioHandler {
  static Dio dio = Dio(BaseOptions(
    validateStatus: (status) {
      if (status == 401) {
        return true;
      } else if (status == 403) {
        return true;
      } else if (status == 500) {
        return true;
      } else if (status == 400) {
        return true;
      } else if (status == 409) {
        return true;
      }
      return status! >= 200 && status < 300;
    },
  ));

  static Future<dynamic> dioPOSTNoAuth({dynamic body, String? endpoint}) async {
    try {
      log(baseUrl + endpoint!);
      log(jsonEncode(body)); // Ensure the body is properly logged

      Response response = await dio
          .post(baseUrl + endpoint,
              data: body,
              options: Options(headers: {"content-type": "application/json"}))
          .timeout(const Duration(seconds: 60));

      log('Response status: ${response.statusCode}');
      log(jsonEncode(
          response.data)); // Convert response to JSON string before logging

      switch (response.statusCode) {
        case 200:
          return response.data;
        case 400:
          return {
            'error': 'Bad Request',
            'message': response.data['message'] ?? 'Invalid input'
          };
        case 401:
          return {
            'error': 'Unauthorized',
            'message': response.data['message'] ?? 'Invalid credentials'
          };
        case 403:
          return {
            'error': 'Forbidden',
            'message': response.data['message'] ?? 'Resource not found'
          };
        case 404:
          return {
            'error': 'Not Found',
            'message': response.data['message'] ?? 'Resource not found'
          };
        case 500:
          return {
            'error': 'Server Error',
            'message': response.data['message'] ?? 'Internal server error'
          };
        default:
          return {
            'error': 'Unexpected Error',
            'message': 'Something went wrong.'
          };
      }
    } catch (e) {
      log("Error caught in catch block: ${e.toString()}");
      return jsonEncode({
        'error': 'Network Error',
        'message': e.toString()
      }); // Ensure returning a String
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
