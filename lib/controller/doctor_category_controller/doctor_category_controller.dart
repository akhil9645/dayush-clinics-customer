import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:get/get.dart';

class DoctorCategoryController extends GetxController {
  RxList doctorsList = [].obs;

  getAvailableCategoryDoctors({String? categoryId}) async {
    try {
      var response = await DioHandler.dioGETWithAuth(
          endpoint: 'doctor/categories/$categoryId/doctors/');

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('doctors')) {
          doctorsList.value =
              List<Map<String, dynamic>>.from(response['doctors']);
        } else {
          log("Doctors key missing in response");
          doctorsList.clear();
        }
      } else {
        log("Response is not a Map<String, dynamic>");
        doctorsList.clear();
      }
    } catch (e) {
      log("Exception: $e");
    }
  }
}
