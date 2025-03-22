import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientInfoView extends StatelessWidget {
  PatientInfoView({super.key});

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController phonenumcontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Patient Info'),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20).r,
          child: ListView(
            children: [
              formHeadingTile('Patient Name'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: namecontroller,
                  validator: (p0) => ValidationHelper.nameValidation(p0 ?? ''),
                  keyboardtype: TextInputType.name,
                  hintText: 'Enter Patient Name'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Age'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: agecontroller,
                  validator: (p0) =>
                      ValidationHelper.normalValidation(p0 ?? ''),
                  keyboardtype: TextInputType.number,
                  hintText: 'Enter Patient Age'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Phone Number'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: phonenumcontroller,
                  validator: (p0) =>
                      ValidationHelper.phoneNumberValidation(p0 ?? ''),
                  keyboardtype: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ).r,
                    child: Text(
                      '+91',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),
                  hintText: 'Enter Patient Phone Number'),
              SizedBox(height: 20.h),
              formHeadingTile('Desease Description'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: descriptioncontroller,
                  validator: (p0) =>
                      ValidationHelper.normalValidation(p0 ?? ''),
                  keyboardtype: TextInputType.text,
                  maxLines: 4,
                  hintText: 'Enter Patient Desease Description'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: CommonWidgets().commonbutton(
          title: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          ontap: () {
            if (formkey.currentState!.validate()) {
              Get.toNamed(PageRoutes.bookappointment);
            }
          },
        ),
      ),
    );
  }

  Row formHeadingTile(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          '*',
          style: TextStyle(color: Color(0xFFED4713), fontSize: 14.sp),
        )
      ],
    );
  }
}
