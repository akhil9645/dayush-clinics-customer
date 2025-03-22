import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookAppointment extends StatelessWidget {
  const BookAppointment({super.key});

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
          'Consult Now',
          // 'Book Appointment',
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
          // Card(
          //   color: Colors.white,
          //   margin: EdgeInsets.zero,
          //   elevation: 2,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12).r,
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(10).r,
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(8).r,
          //           child: Image.asset(
          //             'assets/images/dcc39e9c2cc296b8f484a100aa6a49e9.png',
          //             width: 100.w,
          //             height: 150.h,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         SizedBox(width: 12.w),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Dr. Anjali Raj',
          //                 style: TextStyle(
          //                   fontSize: 14.sp,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               SizedBox(height: 4.h),
          //               Text(
          //                 'Sr Consultant-Ayurveda',
          //                 style: TextStyle(
          //                   color: Colors.grey[600],
          //                   fontSize: 12.sp,
          //                 ),
          //               ),
          //               SizedBox(height: 6.h),
          //               Row(
          //                 children: [
          //                   Icon(Icons.star, color: Colors.amber, size: 18.w),
          //                   SizedBox(width: 4.w),
          //                   Text(
          //                     '4.2',
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 10.w,
          //                   ),
          //                   Text(
          //                     'Next Availability',
          //                     style: TextStyle(
          //                       color: Constants.buttoncolor
          //                           .withValues(alpha: 0.5),
          //                       fontSize: 12.sp,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(height: 8.h),
          //               _buildAvailabilityText('Tomorrow Morning 10:00 AM'),
          //               _buildAvailabilityText('Wednesday Morning 9:00 AM'),
          //               _buildAvailabilityText('Friday Morning 9:00 AM'),
          //               Text(
          //                 'Not Available on Sundays',
          //                 style: TextStyle(
          //                   color: Colors.red[400],
          //                   fontSize: 11.sp,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Constants().h10,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Date',
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 14.sp,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {},
          //       child: Text(
          //         'Change',
          //         style: TextStyle(
          //           color: Colors.grey.shade700,
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Constants().h10,
          // Row(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.all(8).r,
          //       decoration: BoxDecoration(
          //         color: Constants.buttoncolor.withValues(alpha: 0.1),
          //         shape: BoxShape.circle,
          //       ),
          //       child: Icon(Icons.calendar_today, color: Constants.buttoncolor),
          //     ),
          //     SizedBox(width: 12.w),
          //     Text(
          //       'Wednesday, Jun 23, 2021 | 10:00 AM',
          //       style: TextStyle(
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.grey.shade700),
          //     ),
          //   ],
          // ),
          // Constants().h10,
          // Divider(
          //   color: Colors.grey.shade300,
          // ),
          // Constants().h10,
          Text(
            'Payment Detail',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Constants().h10,
          _buildPaymentRow('Consultation', '₹${consultationFee.toString()}'),
          _buildPaymentRow('Platform Fee', '₹${adminFee.toString()}'),
          _buildPaymentRow('Total', '₹${totalAmount.toString()}',
              isTotal: true),
          Constants().h10,
          Divider(
            color: Colors.grey.shade300,
          ),
          // Constants().h10,
          // Text(
          //   'Payment Method',
          //   style: TextStyle(
          //     fontSize: 14.sp,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Constants().h10,
          // Container(
          //   padding: EdgeInsets.all(12).r,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Constants.buttoncolor, width: 0.5.w),
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8).r,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           Image.asset(
          //             'assets/images/visa-icon-2048x628-6yzgq2vq.png',
          //             height: 12.h,
          //           ),
          //           SizedBox(width: 12.w),
          //           Text('•••• 4321'),
          //         ],
          //       ),
          //       Text(
          //         'Change',
          //         style: TextStyle(
          //           color: Colors.grey.shade700,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
            Get.toNamed(PageRoutes.videocallmainpage);
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
