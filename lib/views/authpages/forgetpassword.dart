import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});

  final TextEditingController textcontoller = TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar(),
        body: Padding(
          padding: EdgeInsets.all(25).r,
          child: ListView(
            children: [
              Text(
                'Forgot Your Password?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Enter your email or your phone number, we will send you confirmation code.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            authcontroller.isPhoneSelected.value = false;
                            textcontoller.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.r),
                            decoration: BoxDecoration(
                              color: !authcontroller.isPhoneSelected.value
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: !authcontroller.isPhoneSelected.value
                                  ? Border.all(color: Colors.grey.shade300)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: !authcontroller.isPhoneSelected.value
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight:
                                      !authcontroller.isPhoneSelected.value
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            authcontroller.isPhoneSelected.value = true;
                            textcontoller.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.r),
                            decoration: BoxDecoration(
                              color: authcontroller.isPhoneSelected.value
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: authcontroller.isPhoneSelected.value
                                  ? Border.all(color: Colors.grey.shade300)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  color: authcontroller.isPhoneSelected.value
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight:
                                      authcontroller.isPhoneSelected.value
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => CommonWidgets().commontextformfield(
                  txtcontroller: textcontoller,
                  inputtype: authcontroller.isPhoneSelected.value
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  icon: Icon(
                    authcontroller.isPhoneSelected.value
                        ? Icons.phone
                        : Icons.email_rounded,
                    color: Constants.buttoncolor,
                  ),
                  hinttext: authcontroller.isPhoneSelected.value
                      ? 'Phone Number'
                      : 'Email ID')),
              SizedBox(height: 20.h),
              CommonWidgets().commonbutton(
                title: 'Reset Password',
                ontap: () => Get.toNamed(PageRoutes.resetpassword),
              )
            ],
          ),
        ),
      ),
    );
  }
}
