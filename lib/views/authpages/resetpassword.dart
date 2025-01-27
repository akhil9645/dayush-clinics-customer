import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class Resetpassword extends StatelessWidget {
  Resetpassword({super.key});
  final TextEditingController otpcontroller = TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());

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
    return SafeArea(
      child: Scaffold(
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
                'Enter code that we have sent to your number 9645562970',
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
                title: 'Verify',
                ontap: () {
                  Get.toNamed(PageRoutes.createnewpassword);
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't recieve the code? ",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Constants.buttoncolor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
