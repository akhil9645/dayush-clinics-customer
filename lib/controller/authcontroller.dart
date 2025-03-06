import 'dart:convert';
import 'dart:developer';

import 'package:dayush_clinic/utils/dio_handler.dart';
import 'package:get/get.dart';

class Authcontroller extends GetxController {
  Rx<bool> isPhoneSelected = true.obs;

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

  userLogin(
    String email,
    String password,
  ) async {
    var body = {
      "email": email,
      "password": password,
    };

    // Print the encoded JSON body
    log('Request Body: $body');

    var response =
        await DioHandler.dioPOSTNoAuth(body: body, endpoint: 'accounts/login/');
    if (response != null) {
      log(response.toString());

      return true;
    } else {
      log(response.toString());

      return false;
    }
  }
}
