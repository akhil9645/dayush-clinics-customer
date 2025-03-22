import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:get/get.dart';

class Homecontroller extends GetxController {
  RxList categories = [].obs;

  getAllCategories() async {
    try {
      var response =
          await DioHandler.dioGETWithAuth(endpoint: 'categories/get/');
      if (response != null) {
        categories.value = response;
        log(categories.toString());
      }
    } catch (e) {
      log("Exception : $e");
    }
  }
}
