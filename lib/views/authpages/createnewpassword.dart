import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Createnewpassword extends StatelessWidget {
  Createnewpassword({super.key});

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  final Authcontroller authcontroller = Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar(),
        body: Padding(
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
              CommonWidgets().commontextformfield(
                  hinttext: 'Password',
                  icon: Icon(Icons.password_rounded,
                      color: Constants.buttoncolor),
                  obscuretext: true,
                  txtcontroller: passwordcontroller),
              SizedBox(height: 10.h),
              CommonWidgets().commontextformfield(
                  hinttext: 'Confirm Password',
                  icon: Icon(Icons.password_rounded,
                      color: Constants.buttoncolor),
                  obscuretext: true,
                  txtcontroller: confirmpasswordcontroller),
              SizedBox(height: 20.h),
              CommonWidgets()
                  .commonbutton(ontap: () {}, title: 'Create Password')
            ],
          ),
        ),
      ),
    );
  }
}
