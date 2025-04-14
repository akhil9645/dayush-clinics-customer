import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController fullnamecontroller = TextEditingController();
  final TextEditingController phonnumcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(25).r,
          child: ListView(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                child: Image.asset(
                  'assets/images/e3b510b7d8de3cd2d407cc670c7037e1.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an Account  ',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(PageRoutes.login);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Constants.buttoncolor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              CommonWidgets().commonTextfield(
                  hintText: 'Email ID',
                  validator: (p0) => ValidationHelper.emailValidation(p0 ?? ''),
                  prefixIcon:
                      Icon(Icons.email_rounded, color: Constants.buttoncolor),
                  keyboardtype: TextInputType.emailAddress,
                  textController: emailcontroller),
              SizedBox(
                height: 10.h,
              ),
              CommonWidgets().commonTextfield(
                  validator: (p0) => ValidationHelper.nameValidation(p0 ?? ''),
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person_2_rounded,
                      color: Constants.buttoncolor),
                  keyboardtype: TextInputType.name,
                  textController: fullnamecontroller),
              SizedBox(height: 10.h),
              CommonWidgets().commonTextfield(
                  validator: (p0) =>
                      ValidationHelper.phoneNumberValidation(p0 ?? ''),
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Constants.buttoncolor),
                  keyboardtype: TextInputType.phone,
                  textController: phonnumcontroller),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => CommonWidgets().commonTextfield(
                    validator: (p0) =>
                        ValidationHelper.passwordValidation(p0 ?? ''),
                    hintText: 'Password',
                    obsureText: authcontroller.isobscured.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authcontroller.isobscured.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 20.w,
                      ),
                      onPressed: () {
                        authcontroller.isobscured.value =
                            !authcontroller.isobscured.value;
                      },
                    ),
                    prefixIcon: Icon(Icons.password_rounded,
                        color: Constants.buttoncolor),
                    textController: passwordcontroller),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => CommonWidgets().commonTextfield(
                    validator: (p0) => ValidationHelper.passwordMatchValidation(
                        passwordcontroller.text,
                        confirmpasswordcontroller.text),
                    obsureText: authcontroller.isobscuredForConfirm.value,
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        authcontroller.isobscuredForConfirm.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 20.w,
                      ),
                      onPressed: () {
                        authcontroller.isobscuredForConfirm.value =
                            !authcontroller.isobscuredForConfirm.value;
                      },
                    ),
                    prefixIcon: Icon(Icons.password_rounded,
                        color: Constants.buttoncolor),
                    textController: confirmpasswordcontroller),
              ),
              SizedBox(height: 30.h),
              Obx(() => CommonWidgets().commonbutton(
                    title: authcontroller.isLoading.value
                        ? LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width / 10,
                          )
                        : Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ontap: () async {
                      if (formKey.currentState!.validate()) {
                        print('button pressed');
                        authcontroller.userRegistration(
                            fullnamecontroller.text,
                            emailcontroller.text,
                            passwordcontroller.text,
                            phonnumcontroller.text,
                            confirmpasswordcontroller.text,
                            context);
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
