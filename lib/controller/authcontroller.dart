import 'dart:convert';
import 'dart:developer';

import 'package:dayush_clinic/services/api_endpoints.dart';
import 'package:dayush_clinic/utils/dio_handler.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authcontroller extends GetxController {
  Rx<bool> isPhoneSelected = true.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isobscured = false.obs;
  Rx<bool> isobscuredForConfirm = false.obs;

  userRegistration(
    String username,
    String email,
    String password,
    String phonenumber,
    String confirmpassword,
  ) async {
    var body = {
      "username": username.trim(),
      "email": email.trim(),
      "password": password,
      "password_confirmation": confirmpassword,
      "phone_number": phonenumber.trim(),
    };

    log('Request Body: ${jsonEncode(body)}');

    var response = await DioHandler.dioPOSTNoAuth(
        body: body, endpoint: 'accounts/register/');

    if (response != null) {
      log(jsonEncode(response));
    } else {
      log("Response is null");
    }
    return response;
  }

  userLogin(String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;

      var body = {
        "email": email,
        "password": password,
      };

      log('Request Body: $body');

      var response = await DioHandler.dioPOSTNoAuth(
        body: jsonEncode(body),
        endpoint: ApiEndpoints.login,
      );

      if (response != null && response['access'] != null) {
        log("Login Success: ${response.toString()}");
        isLoading.value = false;
        return true;
      } else {
        log("Login Failed: ${response.toString()}");
        isLoading.value = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(CommonWidgets().snackBarinfo(response['message']));
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      log("Exception: $e");
      return false;
    }
  }
}
