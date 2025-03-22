import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/authpages/otp_screen.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});

  final TextEditingController textcontoller = TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar(''),
      body: Form(
        key: formkey,
        child: Padding(
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
                'Enter your registered email, we will send you confirmation code.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.h),
              CommonWidgets().commonTextfield(
                  textController: textcontoller,
                  validator: (p0) => ValidationHelper.emailValidation(p0 ?? ''),
                  keyboardtype: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: Constants.buttoncolor,
                  ),
                  hintText: 'Email ID'),
              SizedBox(height: 20.h),
              Obx(() => CommonWidgets().commonbutton(
                    title: authcontroller.isLoading.value
                        ? LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width / 10,
                          )
                        : Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ontap: () async {
                      if (formkey.currentState!.validate()) {
                        authcontroller.forgetPassword(
                            textcontoller.text, context);
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
