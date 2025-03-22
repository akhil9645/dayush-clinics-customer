import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString username = ''.obs;
  getUserProfile() async {
    try {
      var response =
          await DioHandler.dioGETWithAuth(endpoint: 'patient/details/');

      if (response != null && response is Map<String, dynamic>) {
        Map<String, dynamic> user = response['user'];

        username.value = user['username'] ?? '';
      } else {
        log("Invalid response format");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }
}
