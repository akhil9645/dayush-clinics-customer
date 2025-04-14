import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentController extends GetxController {
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<String> selectedTimeSlot = ''.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
}
