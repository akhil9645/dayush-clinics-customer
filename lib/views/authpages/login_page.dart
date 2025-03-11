import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
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
                  'assets/images/d0df6aea66a16da88b137e2e5edc2d81.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Login',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp),
              ),
              SizedBox(height: 20.h),
              CommonWidgets().commonTextfield(
                textController: emailcontroller,
                validator: (p0) => ValidationHelper.emailValidation(p0 ?? ''),
                hintText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Constants.buttoncolor,
                ),
                keyboardtype: TextInputType.emailAddress,
              ),
              SizedBox(height: 10.h),
              Obx(
                () => CommonWidgets().commonTextfield(
                  textController: passwordcontroller,
                  obsureText: authcontroller.isobscured.value,
                  validator: (p0) =>
                      ValidationHelper.passwordValidation(p0 ?? ''),
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
                  prefixIcon: Icon(
                    Icons.password_rounded,
                    color: Constants.buttoncolor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(PageRoutes.forgetpassword);
                  },
                  child: const Text(
                    'Forgot?',
                    style: TextStyle(
                        color: Constants.buttoncolor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Obx(
                () => CommonWidgets().commonbutton(
                  title: authcontroller.isLoading.value
                      ? LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      var status = await authcontroller.userLogin(
                          emailcontroller.text,
                          passwordcontroller.text,
                          context);
                      if (status == true) {
                        Get.toNamed(PageRoutes.mainpage);
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to this Platform? ',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(PageRoutes.signup);
                    },
                    child: Text(
                      'Register',
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
