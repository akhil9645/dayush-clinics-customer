import 'dart:developer';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dio/dio.dart';

class DioHandler {
  // static const baseUrl = 'http://65.1.92.125:8080/';
  static const baseUrl =
      'https://2dc8-2401-4900-8fdc-c4be-29a3-dd8c-ad73-78d3.ngrok-free.app/';
  static Dio dio = Dio(BaseOptions(
    validateStatus: (status) {
      if (status == 401) {
        return true;
      } else if (status == 403) {
        return true;
      } else if (status == 404) {
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

  // Function for API calls that do NOT require Authorization
  static Future<dynamic> dioPOSTNoAuth({dynamic body, String? endpoint}) async {
    try {
      // Making the POST request
      log(baseUrl + endpoint!);
      log(body);
      Response response = await dio
          .post(baseUrl + endpoint,
              data: body,
              options: Options(headers: {"content-type": "application/json"}))
          .timeout(const Duration(seconds: 60));

      // Log the response status and body to see what we are getting
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.data}');

      // Handling different status codes
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 201:
          return response.data; // Successful response
        case 400:
          return {
            'error': 'Bad Request',
            'message': response.data['non_field_errors']?.isNotEmpty == true
                ? response.data['non_field_errors'][0]
                : response.data['detail'] ?? 'Invalid input'
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
            'message': response.data?['detail'] ??
                response.data?['message'] ??
                'Resource not found',
          };
        case 409:
          return {
            'error': 'Unexpected Error',
            'message': response.data?['detail'] ??
                response.data?['message'] ??
                'Resource not found',
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
      log("Error caught in catch block: $e");
    }
  }

  // Function for API calls that REQUIRE Authorization
  static Future<dynamic> dioPOSTWithAuth(
      {dynamic body, String? endpoint, dynamic header}) async {
    try {
      var token = await TokenStorageService().getToken();
      dio.options.headers.addAll(header ??
          {
            "Authorization": "Bearer $token",
            "content-type": "application/json"
          });

      Response response = await dio
          .post(baseUrl + endpoint!,
              data: body, options: Options(headers: header))
          .timeout(const Duration(seconds: 60));
      log(baseUrl + endpoint);
      log(response.data.toString());
      log(response.statusCode.toString());

      // Handle different status codes
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 201:
          return response.data; // Success, return the response body
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
        case 409:
          return {
            'error': 'Conflict',
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
            'message': 'Something went wrong'
          };
      }
    } catch (e) {
      log("Error $e");
    }
  }

  static Future<dynamic> dioGETWithAuth(
      {String? endpoint, String? from}) async {
    try {
      var token = await TokenStorageService().getToken();
      dio.options.headers.addAll({
        "Authorization": "Bearer $token",
        "content-type": "application/json"
      });

      Response response = await dio
          .get(
            baseUrl + endpoint!,
          )
          .timeout(const Duration(seconds: 60));
      log(baseUrl + endpoint);
      log(response.data.toString());

      switch (response.statusCode) {
        case 200:
          return response.data;
        case 201:
          return response.data; // Success, return the response body
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
            'message': 'Something went wrong'
          };
      }
    } catch (e) {
      log("Error $e");
    }
  }

  static Future<dynamic> dioGETWithNOAuth({String? endpoint}) async {
    try {
      dio.options.headers.addAll({"content-type": "application/json"});

      Response response = await dio
          .get(
            baseUrl + endpoint!,
          )
          .timeout(const Duration(seconds: 60));

      // Handle different status codes
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 201:
          return response.data; // Success, return the response body
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
            'message': 'Something went wrong'
          };
      }
    } catch (e) {
      log("Error $e");
    }
  }
}
