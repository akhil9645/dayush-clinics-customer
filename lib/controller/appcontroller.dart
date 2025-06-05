import 'dart:convert';
import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:get/get.dart';

class Appcontroller extends GetxController {
  splashCheck() async {
    var token = await TokenStorageService().getToken();
    if (token != null && token.isNotEmpty) {
      Future.delayed(
          Duration(seconds: 3), () => Get.offAllNamed(PageRoutes.homepage));
    } else {
      Future.delayed(Duration(seconds: 3),
          () => Get.offAllNamed(PageRoutes.splashscreendialogue));
    }
  }

  Future<bool> refreshAccessToken() async {
    try {
      var refreshToken = await TokenStorageService().getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        log("No refresh token found");
        return false;
      }

      var body = {"refresh": refreshToken};
      var response = await DioHandler.dioPOSTNoAuth(
        body: jsonEncode(body),
        endpoint: '/accounts/api/token/refresh/',
      );

      if (response != null && response['access'] != null) {
        // Store new access token
        await TokenStorageService().storeToken(response['access']);
        // Store new refresh token if provided (for rotation)
        if (response['refresh'] != null) {
          await TokenStorageService().storeRefreshToken(response['refresh']);
        }
        log("Token refreshed successfully");
        return true;
      } else {
        log("Token refresh failed: ${response.toString()}");
        await TokenStorageService().deleteToken();
        await TokenStorageService().deleteRefreshToken();
        return false;
      }
    } catch (e) {
      log("Error refreshing token: $e");
      await TokenStorageService().deleteToken();
      await TokenStorageService().deleteRefreshToken();
      return false;
    }
  }
}
