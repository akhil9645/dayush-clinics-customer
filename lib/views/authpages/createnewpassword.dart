import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Createnewpassword extends StatelessWidget {
  Createnewpassword({super.key}) : arguments = Get.arguments;

  final dynamic arguments;

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final String email = arguments?['email'] ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar(''),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(25).r,
          child: ListView(
            children: [
              Text(
                'Create New Password',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Create your new password to login',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => CommonWidgets().commonTextfield(
                    textController: passwordcontroller,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        authcontroller.isobscured.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                        size: 20.w,
                      ),
                      onPressed: () {
                        authcontroller.isobscured.value =
                            !authcontroller.isobscured.value;
                      },
                    ),
                    validator: (p0) =>
                        ValidationHelper.passwordValidation(p0 ?? ''),
                    prefixIcon: Icon(Icons.password_rounded,
                        color: Constants.buttoncolor),
                    obsureText: authcontroller.isobscured.value),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => CommonWidgets().commonTextfield(
                    hintText: 'Confirm Password',
                    validator: (p0) => ValidationHelper.passwordMatchValidation(
                        passwordcontroller.text,
                        confirmpasswordcontroller.text),
                    prefixIcon: Icon(Icons.password_rounded,
                        color: Constants.buttoncolor),
                    obsureText: authcontroller.isobscuredForConfirm.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authcontroller.isobscuredForConfirm.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                        size: 20.w,
                      ),
                      onPressed: () {
                        authcontroller.isobscuredForConfirm.value =
                            !authcontroller.isobscuredForConfirm.value;
                      },
                    ),
                    textController: confirmpasswordcontroller),
              ),
              SizedBox(height: 20.h),
              CommonWidgets().commonbutton(
                ontap: () async {
                  if (formkey.currentState!.validate()) {
                    authcontroller.forgetResetPassword(
                        email,
                        passwordcontroller.text,
                        confirmpasswordcontroller.text,
                        context);
                  }
                },
                title: authcontroller.isLoading.value
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width / 10,
                      )
                    : Text(
                        'Create Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
