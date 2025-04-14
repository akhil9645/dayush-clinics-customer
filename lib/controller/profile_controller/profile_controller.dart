import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString username = ''.obs;
  RxString phonenum = ''.obs;
  getUserProfile() async {
    try {
      var response =
          await DioHandler.dioGETWithAuth(endpoint: 'patient/details/');

      if (response != null && response is Map<String, dynamic>) {
        Map<String, dynamic> user = response['user'];

        username.value = user['username'] ?? '';
        phonenum.value = user['phone_number'] ?? '';
      } else {
        log("Invalid response format");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }

  userLogout(BuildContext context) async {
    try {
      var response =
          await DioHandler.dioPOSTWithAuth(endpoint: 'accounts/logout/');
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout successful.'),
          ),
        );
        await TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      } else {}
    } catch (e) {
      log("Exception : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }
}
