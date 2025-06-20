import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class Appcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    splashCheck();
  }

  splashCheck() async {
    developer.log('Starting splashCheck');
    // Check if app was launched from a notification
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data['type'] == 'video_call') {
      developer.log(
          'App launched from video call notification, skipping default navigation');
      return;
    }

    developer.log('Proceeding with default splash navigation');
    var token = await TokenStorageService().getToken();
    if (token != null && token.isNotEmpty) {
      developer.log('Token found, navigating to homepage in 3 seconds');
      Future.delayed(
          Duration(seconds: 3), () => Get.offAllNamed(PageRoutes.homepage));
    } else {
      developer
          .log('No token, navigating to splashscreendialogue in 3 seconds');
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
