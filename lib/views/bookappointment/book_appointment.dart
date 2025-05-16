import 'package:dayush_clinic/controller/book_appointment_controller/book_appointment_controller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointment extends StatefulWidget {
  final dynamic arguments;
  BookAppointment({super.key}) : arguments = Get.arguments;

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final BookAppointmentController bookAppointmentController =
      Get.put(BookAppointmentController());
  Map<String, dynamic>? data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.arguments as Map<String, dynamic>;
    bookAppointmentController.getAppointMentTimeSlots(
        doctorId: data?['doctor']['id'].toString());
  }

  final List<String> timeSlots = [
    '11:00 AM',
    '11:30 AM',
    '02:00 PM',
    '02:20 PM',
    '03:15 PM',
    '03:45 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    double consultationFee = 225.0; // Example consultation fee (can be dynamic)
    double adminFee = consultationFee * 0.05; // 5% of consultation fee
    double totalAmount = consultationFee + adminFee;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          data?['from'] == 'consultnow' ? 'Consult Now' : 'Book Appointment',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10).r,
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20).r,
        child: ListView(children: [
          Card(
            color: Colors.white,
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12).r,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10).r,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8).r,
                    child: Image.asset(
                      'assets/images/dcc39e9c2cc296b8f484a100aa6a49e9.png',
                      width: 100.w,
                      height: 150.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?['doctor']['user']['username'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Sr Consultant-Ayurveda',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        SizedBox(height: 8.h),
                        data?['from'] == 'consultnow'
                            ? Text(
                                'Available Online',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              )
                            : Text(
                                'Select Time Slot',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants().h10,
          data?['from'] == 'consultnow'
              ? SizedBox()
              : Column(
                  children: [
                    Obx(() => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay:
                                bookAppointmentController.focusedDay.value,
                            calendarFormat:
                                bookAppointmentController.calendarFormat.value,
                            selectedDayPredicate: (day) {
                              return isSameDay(
                                  bookAppointmentController.selectedDay.value,
                                  day);
                            },
                            onDaySelected: (
                              selectedDay,
                              focusedDay,
                            ) {
                              bookAppointmentController.selectedDay.value =
                                  selectedDay;
                              bookAppointmentController.focusedDay.value =
                                  focusedDay;
                              bookAppointmentController
                                  .filterSlotsBySelectedDate();
                            },
                            onFormatChanged: (format) {
                              bookAppointmentController.calendarFormat.value =
                                  format;
                            },
                            onPageChanged: (focusedDay) {
                              bookAppointmentController.focusedDay.value =
                                  focusedDay;
                            },
                            enabledDayPredicate: (day) {
                              return bookAppointmentController
                                  .isDateAvailable(day);
                            },
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Color.fromRGBO(73, 135, 255, 0.25),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              selectedDecoration: BoxDecoration(
                                color: Constants.buttoncolor,
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: true,
                              outsideTextStyle:
                                  TextStyle(color: Colors.grey[400]),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronIcon: Icon(Icons.chevron_left),
                              rightChevronIcon: Icon(Icons.chevron_right),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              weekendStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => Text(
                        'Select Time Slot on ${DateFormat('dd/MM/yyyy').format(bookAppointmentController.selectedDay.value)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: bookAppointmentController
                            .filteredSlotsForSelectedDay.length,
                        itemBuilder: (context, index) {
                          var data = bookAppointmentController
                              .filteredSlotsForSelectedDay[index];
                          return Obx(() => ElevatedButton(
                                onPressed: () {
                                  bookAppointmentController
                                      .selectedTimeSlot.value = data.timeSlot;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bookAppointmentController
                                              .selectedTimeSlot.value ==
                                          data.timeSlot
                                      ? Constants.buttoncolor
                                      : Colors.white,
                                  foregroundColor: bookAppointmentController
                                              .selectedTimeSlot.value ==
                                          data.timeSlot
                                      ? Colors.white
                                      : Colors.black,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(data.timeSlot),
                              ));
                        },
                      ),
                    )
                  ],
                ),
          SizedBox(height: 15.h),
          data?['from'] == 'consultnow'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Detail',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Constants().h10,
                    _buildPaymentRow(
                        'Consultation', '₹${consultationFee.toString()}'),
                    _buildPaymentRow('Platform Fee', '₹${adminFee.toString()}'),
                    _buildPaymentRow('Total', '₹${totalAmount.toString()}',
                        isTotal: true),
                    Constants().h10,
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Constants().h10,
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Constants().h10,
                    Container(
                      padding: EdgeInsets.all(12).r,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Constants.buttoncolor, width: 0.5.w),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/visa-icon-2048x628-6yzgq2vq.png',
                                height: 12.h,
                              ),
                              SizedBox(width: 12.w),
                              Text('•••• 4321'),
                            ],
                          ),
                          Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox()
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: CommonWidgets().commonbutton(
          title: Text(
            'Pay Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          ontap: () async {
            if (data?['from'] == 'consultnow') {
              Get.toNamed(PageRoutes.videocallmainpage,
                  arguments: {"consultationId": data?['bookingId']});
            } else {
              bookAppointmentController.doctorSlotBook(
                  categoryId: data?['selectedCategoryId'],
                  doctorId: data?['doctor']['id'],
                  consultationId: data?['bookingId'],
                  selectedDate: DateFormat('yyyy-MM-dd')
                      .format(bookAppointmentController.selectedDay.value),
                  timeSlot: bookAppointmentController.selectedTimeSlot.value);
              Get.toNamed(PageRoutes.paymentDetail);
            }
          },
        ),
      ),
    );
  }
}

Widget _buildAvailabilityText(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 4).r,
    child: Text(
      text,
      style: TextStyle(
        color: Constants.buttoncolor.withValues(alpha: 0.5),
        fontSize: 11.sp,
      ),
    ),
  );
}

Widget _buildPaymentRow(String label, String amount, {bool isTotal = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isTotal ? Constants.buttoncolor : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
