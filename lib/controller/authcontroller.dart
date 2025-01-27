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
      "username": username,
      "email": email,
      "password": password,
      "phone_number": phonenumber,
      "password_confirmation": confirmpassword
    };

    // Print the encoded JSON body
    log('Request Body: $body');

    var response =
        await DioHandler.dioPOST(body: body, endpoint: 'accounts/register/');
    if (response != null) {
      log(response);
    } else {
      log(response);
    }
    return response;
  }
}
