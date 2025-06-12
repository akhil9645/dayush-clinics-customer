import 'dart:convert';
import 'dart:developer' as developer;

import 'package:crypto/crypto.dart';
import 'package:dayush_clinic/controller/book_appointment_controller/book_appointment_controller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointment extends StatefulWidget {
  final dynamic arguments;
  BookAppointment({super.key}) : arguments = Get.arguments;

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final BookAppointmentController bookAppointmentController = Get.put(
    BookAppointmentController(),
  );
  Map<String, dynamic>? data;
  bool isExpanded = false;

  String merchantId = "PHONEPEPGUAT"; // PhonePe-provided Merchant ID
  String appId = "jdkjndkjbdkjbd";
  String flowid = '9999999999';
  final String defaultSaltKey =
      "c817ffaf-8471-48b5-a7e2-a27e5b7efbd3"; // PhonePe-provided Salt Key
  final int defaultSaltIndex = 1; // PhonePe-provided Salt Index
  final String environment = "SANDBOX";
  final String callbackUrl = "";
  bool enableLogging = true;
  String token = '';
  double? totalamount;

  Map<String, dynamic>? phonePeCredentials;
  bool isSdkInitialized = false;

  @override
  void initState() {
    super.initState();
    data = widget.arguments as Map<String, dynamic>;
    initializeApp();
  }

  // Sequential initialization
  Future<void> initializeApp() async {
    try {
      // Fetch time slots
      await bookAppointmentController.getAppointMentTimeSlots(
          doctorId: data?['doctor']['id'].toString());
      // Fetch PhonePe credentials
      await fetchPhonePeCredentials();
      // Log package signature for debugging)
    } catch (e) {
      developer.log("Error during initialization: $e");
    }
  }

  // Fetch PhonePe credentials
  Future<void> fetchPhonePeCredentials() async {
    try {
      phonePeCredentials = await bookAppointmentController.getPhonePeMerchantId(
        data?['bookingId'],
      );
      token = phonePeCredentials?['token'];
      if (phonePeCredentials != null) {
        developer.log("PhonePe Credentials: $phonePeCredentials");
        await initPhonePeSDK();
      } else {
        developer.log("Failed to fetch PhonePe credentials");
      }
    } catch (e) {
      developer.log("Error fetching PhonePe credentials: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching payment credentials: $e")),
        );
      }
    }
  }

  // Initialize PhonePe SDK
  Future<void> initPhonePeSDK() async {
    if (isSdkInitialized) {
      developer.log("PhonePe SDK already initialized");
      return;
    }

    try {
      developer.log(
        "Initializing PhonePe SDK with Environment: $environment, MerchantId: $merchantId, flowId: $flowid, EnableLogging: $enableLogging",
      );
      bool isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowid,
        enableLogging,
      );
      setState(() {
        isSdkInitialized = isInitialized;
      });
      developer.log("PhonePe SDK Initialized: $isInitialized");
    } catch (error, stackTrace) {
      developer.log(
        "Error initializing PhonePe SDK: $error",
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to initialize payment system: $error"),
          ),
        );
      }
    }
  }

  // Generate JSON payload and checksum
  Future<Map<String, String>> generatePaymentPayloadAndChecksum(
      double amount) async {
    try {
      if (phonePeCredentials == null) {
        throw Exception("PhonePe credentials not loaded");
      }

      final payload = {
        "merchantId": merchantId,
        "token": token,
        "orderId": phonePeCredentials!['order_id'] ??
            "TX${DateTime.now().millisecondsSinceEpoch}",
        "merchantUserId": "MUID${data?['doctor']['user']['id'] ?? '123'}",
        "amount": totalamount,
        "callbackUrl": callbackUrl,
        "mobileNumber": "9999999999",
        "paymentMode": {"type": "PAY_PAGE"},
        "flowId": flowid,
      };

      // Encode payload to Base64 for checksum calculation
      String base64Body = base64Encode(utf8.encode(jsonEncode(payload)));
      String checksumInput = "$base64Body/pg/v1/pay$defaultSaltKey";
      String checksum =
          "${sha256.convert(utf8.encode(checksumInput)).toString()}###$defaultSaltIndex";

      // Return JSON payload (not Base64) and checksum separately
      developer.log("Generated JSON Payload: ${jsonEncode(payload)}");
      developer.log("Generated Checksum: $checksum");
      return {"jsonPayload": jsonEncode(payload), "checksum": checksum};
    } catch (e) {
      developer.log("Error generating payment payload: $e");
      throw e;
    }
  }

// Initiate PhonePe transaction
  Future<bool> startPhonePeTransaction(double amount) async {
    try {
      if (!isSdkInitialized) {
        await initPhonePeSDK();
      }

      final paymentData = await generatePaymentPayloadAndChecksum(amount);
      String jsonPayload = paymentData['jsonPayload']!;

      String appSchema =
          ""; // Set your custom app schema if required (optional for Android)

      developer.log("Starting transaction with payload: $jsonPayload");
      Map<dynamic, dynamic>? result = await PhonePePaymentSdk.startTransaction(
        jsonPayload,
        appSchema,
      );

      developer.log("Transaction Result: $result");

      if (result != null) {
        if (result['status'] == 'SUCCESS') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Successful!")),
          );
          // Handle success
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Failed: ${result['error']}")),
          );
          // Handle failure
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction Interrupted")),
        );
      }
    } catch (e, stackTrace) {
      developer.log("Error starting transaction: $e", stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Error: $e")),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String formattedFee = '';
    if (data?['doctor']['consultation_fee'] != null) {
      try {
        double fee = double.parse(
          data!['doctor']['consultation_fee'].toString(),
        );
        formattedFee = fee.toStringAsFixed(0); // Remove decimal places
      } catch (e) {
        formattedFee = 'N/A'; // Fallback if parsing fails
        developer.log("Error parsing consultationFee: $e");
      }
    } else {
      formattedFee = 'N/A'; // Fallback for null
    }
    final fullText = data?['doctor']['description'];
    final words = fullText.split(' ');

    final showSeeMore = words.length > 20;
    final shortText = words.take(20).join(' ');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          data?['from'] == 'consultnow' ? 'Consult Now' : 'Book Appointment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
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
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20).r,
        child: ListView(
          children: [
            doctorDetailCard(formattedFee, showSeeMore, fullText, shortText),
            Constants().h10,
            data?['from'] == 'consultnow'
                ? consultNowWidget(formattedFee)
                : appointmentWidget(formattedFee),
            SizedBox(height: 15.h),
            data?['from'] == 'consultnow'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  )
                : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30).r,
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
            // Parse consultation fee
            double consultationFee = 0.0;
            try {
              consultationFee = totalamount!;
              if (consultationFee < 1 || consultationFee > 1000) {
                throw Exception('Amount must be between ₹1 and ₹1000 for UAT');
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid consultation fee: $e")),
                );
              }
              return;
            }

            bool paymentSuccess = await startPhonePeTransaction(
              consultationFee,
            );

            if (paymentSuccess) {
              if (data?['from'] == 'consultnow') {
                // Navigate to video call page after successful payment
                Get.toNamed(
                  PageRoutes.videocallmainpage,
                  arguments: {
                    'consultationDetails': {
                      'id': data?['bookingId'],
                      'is_booking': false,
                      'is_calling': true,
                    },
                  },
                );
              } else {
                // Validate time slot selection
                if (bookAppointmentController
                    .selectedTimeSlot.value.isNotEmpty) {
                  // Book appointment after successful payment
                  var status = await bookAppointmentController.doctorSlotBook(
                    categoryId: data?['selectedCategoryId'],
                    doctorId: data?['doctor']['id'],
                    consultationId: data?['bookingId'],
                    selectedDate: DateFormat(
                      'yyyy-MM-dd',
                    ).format(bookAppointmentController.selectedDay.value),
                    timeSlot: bookAppointmentController.selectedTimeSlot.value,
                  );

                  if (status == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          backgroundColor: Colors.white,
                          contentPadding: EdgeInsets.all(20.r),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/Animation - 1749205098384.gif',
                                  ),
                                ),
                              ),
                              Text(
                                'Appointment Booked!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Doctor: ${data?['doctor']['user']['username']}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Treatment: ${data?['doctor']['category_name']}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Booked Date: ${DateFormat('dd/MM/yyyy').format(bookAppointmentController.selectedDay.value)}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Booked Time Slot: ${bookAppointmentController.selectedTimeSlot.toString()}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            CommonWidgets().commonbutton(
                              title: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ontap: () {
                                Get.offAllNamed(PageRoutes.homepage);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to book appointment")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CommonWidgets().snackBarinfo('Please select time slot'),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }

  Container doctorDetailCard(
      String formattedFee, showSeeMore, fullText, shortText) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12).r,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10).r,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8).r,
                  child: Image.asset(
                    'assets/images/dcc39e9c2cc296b8f484a100aa6a49e9.png',
                    width: 100.w,
                    height: 120.h,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. ${data?['doctor']['user']['username']}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${data?['doctor']['designation']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '₹$formattedFee per Session',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            color: Constants.buttoncolor,
                            size: 20.sp,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Experience',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${data?['doctor']['years_of_experience'] ?? '0'} Years',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 4.w, // Space between icon and text
                        children: [
                          Icon(
                            Icons.language_rounded,
                            color: Constants.buttoncolor,
                            size: 20.sp,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Languages',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  '${data?['doctor']['languages'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                  ),
                                  softWrap: true, // Allow text to wrap
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              isExpanded || !showSeeMore ? fullText : '$shortText...',
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
            if (showSeeMore)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    isExpanded ? 'See less' : 'See more',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Column consultNowWidget(String amount) {
    final double consultationFee = double.tryParse(amount) ?? 0.0;
    final double platformFee = consultationFee * 0.20;
    final double tax = consultationFee * 0.04;
    totalamount = consultationFee + platformFee + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: Colors.black),
            SizedBox(width: 5.w),
            Text(
              'Payment Details',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade300),
        SizedBox(height: 10.h),

        /// Consultation Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Consultation Fee',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '₹${consultationFee.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),

        /// Platform Fee (20%)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Platform Fee',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '₹${platformFee.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),

        /// Taxes (4%)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Taxes & Other Charges',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '₹${tax.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Divider(color: Colors.grey.shade300),
        SizedBox(height: 5.h),

        /// Total Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
            Text(
              '₹${totalamount?.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column appointmentWidget(String amount) {
    return Column(
      children: [
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: bookAppointmentController.focusedDay.value,
              calendarFormat: bookAppointmentController.calendarFormat.value,
              selectedDayPredicate: (day) {
                return isSameDay(
                  bookAppointmentController.selectedDay.value,
                  day,
                );
              },
              onDaySelected: (selectedDay, focusedDay) {
                bookAppointmentController.selectedDay.value = selectedDay;
                bookAppointmentController.focusedDay.value = focusedDay;
                bookAppointmentController.filterSlotsBySelectedDate();
              },
              onFormatChanged: (format) {
                bookAppointmentController.calendarFormat.value = format;
              },
              onPageChanged: (focusedDay) {
                bookAppointmentController.focusedDay.value = focusedDay;
              },
              enabledDayPredicate: (day) {
                return bookAppointmentController.isDateAvailable(
                  day,
                );
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromRGBO(73, 135, 255, 0.25),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                selectedDecoration: BoxDecoration(
                  color: Constants.buttoncolor,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: true,
                outsideTextStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left),
                rightChevronIcon: Icon(Icons.chevron_right),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Divider(color: Colors.grey.shade300),
        SizedBox(height: 15.h),
        Obx(
          () => Text(
            'Select Time Slot on ${DateFormat('dd/MM/yyyy').format(bookAppointmentController.selectedDay.value)}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 15.h),
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
            itemCount:
                bookAppointmentController.filteredSlotsForSelectedDay.length,
            itemBuilder: (context, index) {
              var data =
                  bookAppointmentController.filteredSlotsForSelectedDay[index];
              return Obx(
                () => ElevatedButton(
                  onPressed: () {
                    bookAppointmentController.selectedTimeSlot.value =
                        data.timeSlot;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        bookAppointmentController.selectedTimeSlot.value ==
                                data.timeSlot
                            ? Constants.buttoncolor
                            : Colors.white,
                    foregroundColor:
                        bookAppointmentController.selectedTimeSlot.value ==
                                data.timeSlot
                            ? Colors.white
                            : Colors.black,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(data.timeSlot),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        Divider(color: Colors.grey.shade300),
        Obx(() => bookAppointmentController.selectedTimeSlot.value.isNotEmpty
            ? consultNowWidget(amount)
            : SizedBox())
      ],
    );
  }
}
