import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:get/get.dart';

class ConsultationController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> appointmentList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> scheduledAppointMentList =
      <Map<String, dynamic>>[].obs;
  RxString downloadUrl = ''.obs;

  getConsulationHistory() async {
    try {
      isLoading.value = true;

      var response = await DioHandler.dioGETWithAuth(
          endpoint: 'patient/consultations-get/');

      if (response != null && response is List) {
        // Clear and add new items
        appointmentList.assignAll(List<Map<String, dynamic>>.from(response));
      } else if (response is Map<String, dynamic> &&
          response['detail'] == 'Given token not valid for any token type') {
        // Handle expired token
        TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      }
    } catch (e) {
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  getScheduledAppointments() async {
    try {
      isLoading.value = true;

      var response =
          await DioHandler.dioGETWithAuth(endpoint: 'patient/bookings-get/');

      if (response != null && response is List) {
        // Clear and add new items
        scheduledAppointMentList
            .assignAll(List<Map<String, dynamic>>.from(response));
      } else if (response is Map<String, dynamic> &&
          response['detail'] == 'Given token not valid for any token type') {
        // Handle expired token
        TokenStorageService().deleteToken();
        Get.offAllNamed(PageRoutes.login);
      }
    } catch (e) {
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  getPrescriptionDownloadUrl(var consultationId) async {
    try {
      var response = await DioHandler.dioGETWithAuth(
          endpoint:
              'doctor/consultations/$consultationId/download-prescription/');
      if (response != null && response.containsKey('download_url')) {
        downloadUrl.value = response['download_url'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Exception : $e");
    }
  }
}
