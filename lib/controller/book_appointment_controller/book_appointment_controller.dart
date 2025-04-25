import 'dart:developer';

import 'package:dayush_clinic/models/appointmentSlotsModel/appointment_slots_model.dart';
import 'package:dayush_clinic/services/dio_handler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentController extends GetxController {
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<String> selectedTimeSlot = ''.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;

  RxList<AppointmentSlot> appointmentSlots = <AppointmentSlot>[].obs;
  RxList<DateTime> availableDates = <DateTime>[].obs;

  RxList<AppointmentSlot> filteredSlotsForSelectedDay = <AppointmentSlot>[].obs;

  getAppointMentTimeSlots({String? doctorId}) async {
    try {
      var response = await DioHandler.dioGETWithAuth(
        endpoint: 'patient/available-slots/$doctorId',
      );

      if (response != null && response is List) {
        List<AppointmentSlot> allSlots =
            response.map((json) => AppointmentSlot.fromJson(json)).toList();

        // Remove duplicates based on (date + timeSlot)
        final uniqueSlots = <AppointmentSlot>{};
        for (var slot in allSlots) {
          uniqueSlots.add(slot);
        }

        appointmentSlots.value = uniqueSlots.toList();

        // Extract unique dates
        Set<DateTime> uniqueDates =
            uniqueSlots.map((e) => DateTime.parse(e.date)).toSet();
        availableDates.value = uniqueDates.toList()..sort();

        if (availableDates.isNotEmpty) {
          focusedDay.value = availableDates.first;
          selectedDay.value = availableDates.first;
          filterSlotsBySelectedDate();
        }
      }
    } catch (e) {
      log("Exception: $e");
    }
  }

  void filterSlotsBySelectedDate() {
    filteredSlotsForSelectedDay.value = appointmentSlots
        .where((slot) =>
            slot.date == DateFormat('yyyy-MM-dd').format(selectedDay.value))
        .toList();
  }

  bool isDateAvailable(DateTime day) {
    return availableDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day);
  }

  doctorSlotBook(
      {var doctorId,
      var categoryId,
      var selectedDate,
      var timeSlot,
      var consultationId}) async {
    try {
      var body = {
        "consultationId": consultationId,
        "doctor_id": doctorId,
        "category_id": categoryId,
        "date": selectedDate,
        "time_slot": timeSlot
      };
      log(body.toString());
      var response = await DioHandler.dioPOSTWithAuth(
          body: body, endpoint: 'patient/book-appointment/');
      if (response != null) {
      } else {}
    } catch (e) {
      log("Exception : $e");
    }
  }
}
