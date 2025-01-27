import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController fullnamecontroller = TextEditingController();
  final TextEditingController phonnumcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
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
              SizedBox(height: 20.h),
              Text(
                'Or, Register with an Email',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              CommonWidgets().commontextformfield(
                  hinttext: 'Email ID',
                  icon: Icon(Icons.email_rounded, color: Constants.buttoncolor),
                  inputtype: TextInputType.emailAddress,
                  txtcontroller: emailcontroller),
              SizedBox(
                height: 10.h,
              ),
              CommonWidgets().commontextformfield(
                  hinttext: 'Full Name',
                  icon: Icon(Icons.person_2_rounded,
                      color: Constants.buttoncolor),
                  inputtype: TextInputType.name,
                  txtcontroller: fullnamecontroller),
              SizedBox(height: 10.h),
              CommonWidgets().commontextformfield(
                  hinttext: 'Phone Number',
                  icon: Icon(Icons.phone, color: Constants.buttoncolor),
                  inputtype: TextInputType.phone,
                  txtcontroller: phonnumcontroller),
              SizedBox(
                height: 10.h,
              ),
              CommonWidgets().commontextformfield(
                  hinttext: 'Password',
                  obscuretext: true,
                  icon: Icon(Icons.password_rounded,
                      color: Constants.buttoncolor),
                  txtcontroller: passwordcontroller),
              SizedBox(height: 10.h),
              CommonWidgets().commontextformfield(
                  obscuretext: true,
                  hinttext: 'Confirm Password',
                  icon: Icon(Icons.password_rounded,
                      color: Constants.buttoncolor),
                  txtcontroller: confirmpasswordcontroller),
              SizedBox(height: 30.h),
              CommonWidgets().commonbutton(
                title: 'Sign Up',
                ontap: () {
                  print('button pressed');
                  authcontroller.userRegistration(
                      fullnamecontroller.text,
                      emailcontroller.text,
                      passwordcontroller.text,
                      phonnumcontroller.text,
                      confirmpasswordcontroller.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
