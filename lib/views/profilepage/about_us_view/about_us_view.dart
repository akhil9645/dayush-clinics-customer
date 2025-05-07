import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('About Us'),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15).r,
        child: ListView(
          children: [
            Text("Dayush Clinics",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 15.h),
            Text('Trusted Traditional Care - Delivered Digitally',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            Text(
                'Dayush Clinics brings expert traditional healing to your fingertips. We offer direct video consultations with highly experienced doctors and practitioners (minimum 8 years experience) in Ayurveda, Siddha, Naturopathy, Unani, Homeopathy, and Yoga.',
                style: TextStyle(
                  fontSize: 14.sp,
                )),
            SizedBox(height: 15.h),
            Text(
                "Connect instantly or schedule an appointment easily—no travel, no long waits. Consultations are offered at near-free cost, and you'll receive a digital prescription ready for download after your session.",
                style: TextStyle(
                  fontSize: 14.sp,
                )),
            SizedBox(height: 15.h),
            Text(
                "At Dayush Clinics, we combine ancient wisdom with modern convenience to make authentic, holistic care accessible anytime, anywhere.",
                style: TextStyle(
                  fontSize: 14.sp,
                ))
          ],
        ),
      ),
    );
  }
}
