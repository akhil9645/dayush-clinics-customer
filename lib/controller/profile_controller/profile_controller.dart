import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString username = ''.obs;
  RxString phonenum = ''.obs;
  RxString email = ''.obs;
  getUserProfile() async {
    try {
      var response =
          await DioHandler.dioGETWithAuth(endpoint: 'patient/details/');
      log("ithinte response ${response.toString()}");

      if (response != null &&
          response is Map<String, dynamic> &&
          response.containsKey('user')) {
        log('gone inside');
        Map<String, dynamic> user = response['user'];

        username.value = user['username'] ?? '';
        phonenum.value = user['phone_number'] ?? '';
        email.value = user['email'] ?? '';
      } else if (response != null &&
          response['detail'] == 'Given token not valid for any token type') {
        log('not gone inside');
        TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      } else if (response['error'] == 'Unauthorized') {
        TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      }
    } catch (e) {
      TokenStorageService().deleteToken();
      Get.offAllNamed(PageRoutes.login);
      log("Exception: $e");
    }
  }

  userLogout(BuildContext context) async {
    try {
      var refreshtoken = await TokenStorageService().getRefreshToken();
      var body = {"refresh_token": refreshtoken};
      var response = await DioHandler.dioPOSTWithAuth(
          endpoint: 'accounts/logout/', body: body);
      if (response != null &&
          response['message'] == 'User logged out successfully.') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout successful.'),
          ),
        );
        await TokenStorageService().deleteRefreshToken();
        await TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    } catch (e) {
      log("Exception : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }
}
