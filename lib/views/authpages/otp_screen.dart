import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatefulWidget {
  final String email;
  final String from;

  const VerifyOtp({super.key, required this.email, required this.from});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController otpcontroller = TextEditingController();

  final Authcontroller authcontroller = Get.put(Authcontroller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authcontroller.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultpintheme = PinTheme(
        width: 55.w,
        height: 55.h,
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        decoration: BoxDecoration(
            color: Color(0xFFB0C7E6).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent)));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar(),
      body: Padding(
        padding: EdgeInsets.all(25.r),
        child: ListView(
          children: [
            Text(
              'Enter Verification Code',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Enter code that we have sent to your email ${widget.email}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              child: Pinput(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  } else if (value.length != 4) {
                    return 'Enter a valid OTP of 4 digits';
                  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'OTP should contain only numbers';
                  }
                  return null;
                },
                length: 4,
                defaultPinTheme: defaultpintheme,
                pinContentAlignment: Alignment.center,
                separatorBuilder: (index) => SizedBox(
                  width: 15.w,
                ),
                focusedPinTheme: defaultpintheme.copyWith(
                    decoration: defaultpintheme.decoration!.copyWith(
                        border: Border.all(color: Constants.buttoncolor))),
                onCompleted: (value) {
                  otpcontroller.text = value;
                },
              ),
            ),
            SizedBox(height: 20.h),
            CommonWidgets().commonbutton(
              title: authcontroller.isLoading.value
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 10,
                    )
                  : Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ontap: () async {
                widget.from == 'userverify'
                    ? authcontroller.validateOtp(
                        widget.email, otpcontroller.text, context)
                    : authcontroller.forgetPassvalidateOtp(
                        widget.email, otpcontroller.text, context);
              },
            ),
            SizedBox(height: 20.h),
            Obx(() {
              int minutes = authcontroller.countdown.value ~/ 60;
              int seconds = authcontroller.countdown.value % 60;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "OTP will expire in ",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  Text(
                    "$minutes:${seconds.toString().padLeft(2, '0')}", // Format as MM:SS
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Constants.buttoncolor,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
