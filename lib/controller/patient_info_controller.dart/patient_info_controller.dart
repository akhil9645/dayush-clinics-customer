import 'dart:developer';

import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:get/get.dart';

class PatientInfoController extends GetxController {
  Rx<bool> isCheckedAgreement = false.obs;
  Rx<bool> isLoading = false.obs;
  addPatientInfo(
      {String? patientName,
      String? patientAge,
      String? phoneNum,
      var doctorId,
      var categoryId,
      var amount,
      String? email,
      String? gender,
      bool? directConsultation,
      String? patientDescription}) async {
    try {
      isLoading.value = true;
      var body = {
        "doctor_id": doctorId,
        "category_id": categoryId.toString(),
        "patient_name": patientName,
        "age": int.parse(patientAge ?? ''),
        "phone_number": phoneNum,
        "disease_description": patientDescription,
        "gender": gender,
        "email": email,
        "direct_consultation": directConsultation,
        "amount": amount
      };
      log(body.toString());
      var response = await DioHandler.dioPOSTWithAuth(
          body: body, endpoint: 'patient/consultations/book/');
      if (response != null &&
          response['message'] == 'Consultation booked successfully!') {
        isLoading.value = false;
        var bookingId = response['data']['id'] ?? 0;
        return bookingId;
      } else {
        isLoading.value = false;
        return 0;
      }
    } catch (e) {
      log("Exception : $e");
      return 0;
    }
  }
}
