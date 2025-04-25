import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Notification'),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/notification_page_message.svg",
                width: 96.w,
                height: 96.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "No Notifications",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              Text(
                "We'll let you know when there will be something to update you.",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
