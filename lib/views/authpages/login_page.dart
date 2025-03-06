import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
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
              CommonWidgets().commontextformfield(
                  txtcontroller: emailcontroller,
                  hinttext: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Constants.buttoncolor,
                  ),
                  inputtype: TextInputType.emailAddress),
              SizedBox(height: 10.h),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  CommonWidgets().commontextformfield(
                    txtcontroller: passwordcontroller,
                    obscuretext: true,
                    hinttext: 'Password',
                    icon: Icon(
                      Icons.password_rounded,
                      color: Constants.buttoncolor,
                    ),
                  ),
                  TextButton(
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
                ],
              ),
              SizedBox(height: 35.h),
              CommonWidgets().commonbutton(
                title: 'Login',
                ontap: () async {
                  var status = await authcontroller.userLogin(
                      emailcontroller.text, passwordcontroller.text);
                  if (status == true) {
                    Get.toNamed(PageRoutes.mainpage);
                  }
                },
              ),
              SizedBox(height: 35.h),
              Text(
                'Or, login with',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var svgIcon in [
                    'assets/svg/authicons/google.svg',
                    'assets/svg/authicons/meta.svg',
                    'assets/svg/authicons/apple.svg',
                  ])
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SvgPicture.asset(svgIcon),
                      ),
                    ),
                ],
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
